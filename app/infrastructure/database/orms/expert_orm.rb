# frozen_string_literal: true

module SMS
  module Database
    # Object Relational Mapper for Expert Entities
    class ExpertOrm < Sequel::Model(:experts)
      one_to_many :tweets,
                  class: :'SMS::Database::TweetOrm',
                  key: :owner_id

      plugin :timestamps, update_on_create: true

      def self.find_or_create(expert_info)
        first(user_id: expert_info[:user_id]) || create(expert_info)
      end
    end
  end
end
