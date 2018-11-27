# frozen_string_literal: true

require 'dry/monads/result'

module SMS
  module Service
    # Transaction to add Cve
    class CVEList
      include Dry::Monads::Result::Mixin

      def call(cve_list)
        cves = Repository::For.klass(Entity::CVE)
          .find_list_id(cve_list)

        Success(cves)
      rescue StandardError
        Failure('Could not access database')
      end
    end
  end
end
