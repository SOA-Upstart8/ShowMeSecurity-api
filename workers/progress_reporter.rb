# frozen_string_literal: true

require 'http'

module Filter
  # Reports progress as percent to Faye endpoint
  class ProgressReporter
    def initialize(api_host, channel_id)
      @api_host = api_host
      @channel_id = channel_id
    end

    def publish(message)
      print "Progress: #{message} "
      print "[post: #{@api_host}/faye] "
      response = HTTP.headers(content_type: 'application/json')
        .post(
          "#{@api_host}/faye",
          body: message_body(message)
        )
      puts "(#{response.status})"
    rescue HTTP::ConnectionError
      puts '(Faye server not found - progress not sent)'
    end

    private

    def message_body(message)
      { channel: "/#{@channel_id}",
        data: message }.to_json
    end
  end
end
