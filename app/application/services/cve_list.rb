# frozen_string_literal: true

require 'dry/monads/result'

module SMS
  module Service
    # Return all database cves
    class CVEList
      include Dry::Transaction
      include Dry::Monads::Result::Mixin

      step :retrieve_cves

      def retrieve_cves
        Repository::For.klass(Entity::CVE)
          .all
          .yield_self do |cve|
            Success(Value::Result.new(status: :ok, message: cve))
          end
      rescue StandardError
        Failure(Value::Result.new(status: :internal_error,
                                  message: 'Cannot access database'))
      end
    end
  end
end
