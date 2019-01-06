# frozen_string_literal: true

require 'dry/transaction'

module SMS
  module Service
    # Return TOP5 CVEs
    class CVETop
      include Dry::Transaction

      step :acquire_cves
      step :return_cves

      private

      SMS_NOT_FOUND_MSG = 'Could not find cves on Secbuzzer'

      # call best_cve
      def acquire_cves
        input = cve_from_secbuzzer
        Success(input)
      rescue StandardError => error
        Failure(Value::Result.new(status: :not_found,
                                  message: error.to_s))
      end

      def return_cves(input)
        input.each { |cve| Value::TopCVEsList.new(cve) }
          .yield_self do |list|
            Success(Value::Result.new(status: :ok, message: list))
          end
      rescue StandardError => error
        Failure(Value::Result.new(status: :not_found,
                                  message: error.to_s))
      end

      def cve_from_secbuzzer
        SMS::CVE::BestMapper.new(Api.config.SEC_API_KEY).best
      rescue StandardError
        raise SMS_NOT_FOUND_MSG
      end
    end
  end
end
