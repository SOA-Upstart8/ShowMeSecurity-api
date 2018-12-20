# frozen_string_literal: true

require 'dry/transaction'

module SMS
  module Service
    # Return OWASP TOP10 category CVE
    class CVEOwasp
      include Dry::Transaction

      step :validate_input
      step :get_cves
      step :return_cves

      private

      SMS_NOT_FOUND_MSG = 'Please check your query again.'
      PROCESSING_MSG = 'We are searching the database, please wait 3 seconds!'

      OWASP_TOP10 = %w[Injection Authentication Exposure XXE Access
                       Misconfigurations XSS Deserialization Vulnerabilities Monitoring].freeze

      # validate user query
      def validate_input(input)
        found = false, query = ''
        OWASP_TOP10.each do |word|
          found = true, query = word if input.casecmp(word).zero?
        end
        return(Success(query)) unless query.empty?

        Failure(Value::Result.new(status: :not_found, message: SMS_NOT_FOUND_MSG))
      rescue StandardError
        Failure(Value::Result.new(status: :not_found, message: SMS_NOT_FOUND_MSG))
      end

      # call search_cve(category)
      def get_cves(input)
        if check_database_exist?(input)
          Success(SMS::Repository::Owasps.find_category(input))
        else
          Messaging::Queue.new(Api.config.FILITER_QUEUE_URL, Api.config)
            .send(input)
          Failure(Value::Result.new(status: :processing, message: PROCESSING_MSG))
        end
      rescue StandardError => error
        Failure(Value::Result.new(status: :not_found,
                                  message: error.to_s))
      end

      def return_cves(input)
        input.each { |cve| Value::CVEsList.new(cve) }
          .yield_self do |list|
            Success(Value::Result.new(status: :ok, message: list))
          end
      rescue StandardError => error
        Failure(Value::Result.new(status: :not_found,
                                  message: error.to_s))
      end

      def check_database_exist?(query)
        SMS::Repository::Owasps.find_category_count(query).zero? ? false : true
      end

      def cve_from_secbuzzer(input)
        SMS::Mapper::CVEMapper.new(input).filter
      rescue StandardError
        raise SMS_NOT_FOUND_MSG
      end
    end
  end
end
