# frozen_string_literal: true

module SMS
  module Database
    # Object Relational Mapper for Tweet Entities
    class TweetOrm < Sequel::Model(:tweets)
      many_to_one :cve,
                  class: :'SMS::Database::CVEOrm'

      plugin :timestamps, update_on_create: true
    end
  end
end
