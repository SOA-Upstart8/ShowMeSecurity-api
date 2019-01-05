# frozen_string_literal: true

require 'dry/transaction'

module SMS
  module Service
    # Return OWASP TOP10 category CVE
    class CVELatest
      include Dry::Transaction

      step :acquire_cves
      step :return_cves

      private

      SMS_NOT_FOUND_MSG = 'Could not get cves on Secbuzzer'

      # call search_cve(category)
      def acquire_cves
        result = cve_from_secbuzzer
        Success(result)
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

      def cve_from_secbuzzer
        result = SMS::CVE::CVEMapper.new(Api.config.SEC_API_KEY).latest
        result.each do |cve|
          Repository::For.entity(cve).create(cve)
        end
      rescue StandardError
        raise SMS_NOT_FOUND_MSG
      end
    end
  end
end
