# frozen_string_literal: true

module SMS
  module Database
    # Object Relational Mapper for CVE Entities
    class CVEOrm < Sequel::Model(:cves)
      one_to_many :tweets,
                  class: :'SMS::Database::TweetOrm',
                  key: :cve_id

      one_to_many :references,
                  class: :'SMS::Database::ReferenceOrm',
                  key: :cve_id

      plugin :timestamps, update_on_create: true
    end
  end
end
