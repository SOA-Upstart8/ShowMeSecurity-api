# frozen_string_literal: true

require 'dry/transaction'

module SMS
  module Service
    # Return Vultype statistic
    class Vultype
      include Dry::Transaction

      step :get_data
      step :return_data

      private

      SMS_NOT_FOUND_MSG = 'Could not retrieve data from Secbuzzer'

      # call VulMapper
      def get_data
        input = data_from_secbuzzer
        Success(input)
      rescue StandardError => error
        Failure(Value::Result.new(status: :not_found,
                                  message: error.to_s))
      end

      def return_data(input)
        input.each { |type| Value::VultypesList.new(type) }
          .yield_self do |list|
            Success(Value::Result.new(status: :ok, message: list))
          end
      rescue StandardError => error
        Failure(Value::Result.new(status: :not_found,
                                  message: error.to_s))
      end

      def data_from_secbuzzer
        SMS::CVE::VulMapper.new(Api.config.SEC_API_KEY).best
      rescue StandardError
        raise SMS_NOT_FOUND_MSG
      end
    end
  end
end
