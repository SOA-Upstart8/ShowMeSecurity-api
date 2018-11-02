# frozen_string_literal: true

module SMS
  module Database
    # Object Relational Mapper for Reference Entities
    class ReferenceOrm < Sequel::Model(:references)
      many_to_one :cve,
                  class: :'SMS::Database::CVEOrm'

      plugin :timestamps, update_on_create: true
    end
  end
end
