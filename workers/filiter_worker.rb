# frozen_string_literal: true

require_relative '../init.rb'

require 'amatch'
require 'econfig'
require 'shoryuken'

require_relative 'progress_reporter.rb'
require_relative 'progress_monitor.rb'
module Filter
  # Shoryuken worker class to filiter cves in parallel
  class FilterWorker
    extend Econfig::Shortcut
    Econfig.env = ENV['RACK_ENV'] || 'development'
    Econfig.root = File.expand_path('..', File.dirname(__FILE__))
    Shoryuken.sqs_client = Aws::SQS::Client.new(
      access_key_id: config.AWS_ACCESS_KEY_ID,
      secret_access_key: config.AWS_SECRET_ACCESS_KEY,
      region: config.AWS_REGION
    )

    include Shoryuken::Worker
    Shoryuken.sqs_client_receive_message_opts = { wait_time_seconds: 20 }
    shoryuken_options queue: config.FILITER_QUEUE_URL, auto_delete: true

    def perform(_sqs_msg, request)
      request = JSON.parse request
      reporter = setup_job(request['request_id'])
      reporter.publish(Monitor.starting_percent)
      result = SMS::Mapper::CVEMapper.new(request['category']).filter
      reporter.publish(Monitor.percent('RETRIEVE'))

      thirty, sixty, ninety = count_ratio(result.size)
      result.each_with_index do |cve, index|
        SMS::Repository::Owasps.create(cve)
        check_progress(index, thirty, sixty, ninety)
      end
      # Keep sending finished status to any latecoming subscribers
      each_second(5) { reporter.publish(Monitor.finished_percent) }
    end

    def count_ratio(total)
      thirty = (total * 0.3).round
      sixty  = (total * 0.6).round
      ninety = (total * 0.9).round
      [thirty, sixty, ninety]
    end

    def check_progress(index, thirty, sixty, ninety)
      reporter.publish(Monitor.percent('THIRTY')) if index == thirty
      reporter.publish(Monitor.percent('SIXTY')) if index == sixty
      reporter.publish(Monitor.percent('NINETY')) if index == ninety
    end

    def setup_job(request_id)
      api_host = FilterWorker.config.API_HOST
      ProgressReporter.new(api_host, request_id)
    end
    
    def each_second(seconds)
      seconds.times do
        sleep(1)
        yield if block_given?
      end
    end
  end
end
