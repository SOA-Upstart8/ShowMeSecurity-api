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

      SMS_NOT_FOUND_MSG = 'Could not find cves on Secbuzzer'
      PROCESSING_MSG = 'We are searching the database, please wait 3 sec!'

      OWASP_TOP10 = %w[Injection Authentication Exposure XXE Access
                       Misconfigurations XSS Deserialization Vulnerabilities Monitoring].freeze

      # validate user query
      def validate_input(input)
        found = false, query = ''
        OWASP_TOP10.each do |word|
          found = true, query = word if input.casecmp(word).zero?
        end
        Success(query) if found
      rescue StandardError => error
        Failure(Value::Result.new(status: :not_found, message: error.to_s))
      end

      # call search_cve(category)
      def get_cves(input)
        Messaging::Queue.new(Api.config.FILITER_QUEUE_URL, Api.config)
          .send(input)
        Failure(Value::Result.new(status: :processing, message: PROCESSING_MSG))
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

      def cve_from_secbuzzer(input)
        SMS::Mapper::CVEMapper.new(input).filter
      rescue StandardError
        raise SMS_NOT_FOUND_MSG
      end
    end
  end
end
