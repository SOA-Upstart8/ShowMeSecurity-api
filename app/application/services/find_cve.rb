# frozen_string_literal: true

require 'dry/transaction'

module SMS
  module Service
    # Return CVE detail
    class FindCVE
      include Dry::Transaction

      step :acquire_data
      step :return_cve

      private

      DATABASE_ERROR_MSG = 'Could not access database'

      # call search_cve(category)
      def acquire_data(input)
        puts "cveID=#{input}"
        cve_entity = cve_from_database(input)
        Success(cve_entity)
      rescue StandardError => error
        Failure(Value::Result.new(status: :not_found,
                                  message: error.to_s))
      end

      def return_cve(input)
        Success(Value::Result.new(status: :ok, message: input))
      rescue StandardError => error
        Failure(Value::Result.new(status: :not_found,
                                  message: error.to_s))
      end

      def cve_from_database(cve_id)
        cve = SMS::Repository::CVEs.find_cve_id(cve_id)
        return cve unless cve.nil?

        cve = SMS::CVE::CVEMapper.new(Api.config.SEC_API_KEY).find_by_cveid(cve_id)
        puts cve
        Repository::For.entity(cve).create(cve)
      rescue StandardError
        raise DATABASE_ERROR_MSG
      end
    end
  end
end
