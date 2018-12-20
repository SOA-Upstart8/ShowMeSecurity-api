# frozen_string_literal: true

module SMS
  module Database
    # Object Relational Mapper for Owasp Reference Entities
    class OwaspRefOrm < Sequel::Model(:owasp_refs)
      many_to_one :owasps,
                  class: :'SMS::Database::OwaspOrm'

      plugin :timestamps, update_on_create: true
    end
  end
end
