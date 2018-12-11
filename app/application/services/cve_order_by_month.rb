# frozen_string_literal: true

require 'dry/transaction'
require 'time'

module SMS
  module Service
    # Return number of cve every month
    class CVEOrderMonth
      include Dry::Transaction

      step :get_cves
      step :count_number
      step :return_result

      private

      SMS_DATABASE_ERROR_MSG = 'Can\'t access database'
      MONTHS = ['2018-01-31', '2018-02-28', '2018-03-31', '2018-04-30',
                '2018-05-31', '2018-06-30', '2018-07-31', '2018-08-31',
                '2018-09-30', '2018-10-31', '2018-11-30', '2018-12-31'].freeze

      # call search_cve(category)
      def get_cves
        input = Repository::For.klass(Entity::CVE).all
        Success(input)
      rescue StandardError => error
        Failure(Value::Result.new(status: :not_found,
                                  message: SMS_DATABASE_ERROR_MSG))
      end

      def count_number(input)
        month_arr = []
        MONTHS.each do |month|
          number = 0
          compare_date = Date.parse(month)
          input.each do |cve|
            next unless compare_date(cve.release_date, compare_date)

            number += 1
            input.delete(cve)
          end
          month_arr << SMS::Value::Month.new(month, number)
        end
        Success(month_arr)
      rescue StandardError => error
        Failure(Value::Result.new(status: :not_found,
                                  message: error.to_s))
      end

      def return_result(input)
        Success(Value::Result.new(status: :ok,
                                  message: input))
      end

      def compare_date(date1, date2)
        date1 = date1.to_date
        date1 <= date2
      end
    end
  end
end
