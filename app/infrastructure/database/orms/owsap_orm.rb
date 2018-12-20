# frozen_string_literal: true

module SMS
  module Database
    # Object Relational Mapper for Owasp Entities
    class OwaspOrm < Sequel::Model(:owasps)
      one_to_many :owasp_refs,
                  class: :'SMS::Database::OwaspRefOrm',
                  key: :cve_id

      plugin :timestamps, update_on_create: true
    end
  end
end
