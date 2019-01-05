# frozen_string_literal: true

require 'dry/monads/result'
require 'dry/transaction'

module SMS
  module Service
    # Return all database cves
    class CVEList
      include Dry::Transaction
      include Dry::Monads::Result::Mixin

      step :retrieve_cves

      def retrieve_cves
        cves = Repository::For.klass(Entity::CVE).all
        list = SMS::Entity::CVEs.new(cves: cves)

        Success(Value::Result.new(status: :ok, message: list))
      rescue StandardError
        Failure(Value::Result.new(status: :internal_error,
                                  message: 'Cannot access database'))
      end
    end
  end
end
