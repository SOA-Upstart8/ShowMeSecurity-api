# frozen_string_literal: true

require 'dry/transaction'

module SMS
  module Service
    # Return OWASP TOP10 category CVE
    class CVEOwasp
      include Dry::Transaction

      # step :validate_input
      step :get_cves
      step :return_cves

      private

      SMS_NOT_FOUND_MSG = 'Could not find cves on Secbuzzer'

      OWASP_TOP10 = %w[injection authentication exposure xxe access
                       misconfigurations xss deserialization vulnerabilities monitoring].freeze

      # validate user query
      def validate_input(input)
        OWASP_TOP10.each do |word|
          input = input.downcase

          Success(Value::Result.new(status: :ok, message: input)) if input.include? word
        end
      rescue StandardError => error
        Failure(Value::Result.new(status: :not_found,
                                  message: error.to_s))
      end

      # call search_cve(category)
      def get_cves(input)
        input[:result] = cve_from_secbuzzer(input)
        Success(input)
      rescue StandardError => error
        Failure(Value::Result.new(status: :not_found,
                                  message: error.to_s))
      end

      def return_cves(input)
        input[:result].each do |cve|
          Success(Value::Result.new(status: :ok, message: cve))
        end
      rescue StandardError => error
        Failure(Value::Result.new(status: :not_found,
                                  message: error.to_s))
      end

      def cve_from_secbuzzer(input)
        Mapper::CVEMapper.new(input).filter
      rescue StandardError
        raise SMS_NOT_FOUND_MSG
      end
    end
  end
end
