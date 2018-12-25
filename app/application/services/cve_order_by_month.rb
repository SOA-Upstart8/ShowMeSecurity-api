# frozen_string_literal: true

require 'dry/transaction'
require 'time'
require 'concurrent'

module SMS
  module Service
    # Return number of cve every month
    class CVEOrderMonth
      include Dry::Transaction

      step :count_number
      step :return_result

      private

      SMS_DATABASE_ERROR_MSG = 'Can\'t access database'
      MONTHS = ['2018-01-01', '2018-02-01', '2018-03-01', '2018-04-01',
                '2018-05-01', '2018-06-01', '2018-07-01', '2018-08-01',
                '2018-09-01', '2018-10-01', '2018-11-01', '2018-12-01',
                '2018-12-31'].freeze

      def count_number
        month_arr = []
        MONTHS.each_with_index do |month, index|
          next if index == 12

          Concurrent::Promise
            .new { get_every_month(MONTHS[index], MONTHS[index + 1]) }
            .then { |number| month_arr << SMS::Value::Month.new(month, number) }
            .execute
        end

        sleep(3)
        month_arr = month_arr.sort_by(&:date)
        Success(month_arr)
      rescue StandardError => error
        Failure(Value::Result.new(status: :not_found,
                                  message: error.to_s))
      end

      def return_result(input)
        Success(Value::Result.new(status: :ok,
                                  message: input))
      end

      def get_every_month(from, to)
        SMS::CVE::CVEMapper.new(Api.config.SEC_API_KEY)
          .every_month_num(from, to)
      end
    end
  end
end
