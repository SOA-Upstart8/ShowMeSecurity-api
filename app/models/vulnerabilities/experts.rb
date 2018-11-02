# frozen_string_literal: true

module SMS
  module Vulnerability
    # Vulnerability for Experts
    class Experts
      def self.all
        Database::ExpertOrm.all.map { |expert| rebuild_entity(expert) }
      end

      def self.find_id(id)
        rebuild_entity Database::ExpertOrm.first(id: id)
      end

      def self.find_user_id(user_id)
        rebuild_entity Database::ExpertOrm.first(user_id: user_id)
      end

      def self.find_name(name)
        db_experts = Database::ExpertOrm
          .where(Sequel.like(:title, "%#{name}%"))
          .all
        rebuild_entity db_experts
      end

      def self.find(entity)
        find_id(entity.id)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Expert.new(
          id: db_record.id,
          user_id: db_record.user_id,
          image: db_record.image,
          follower_count: db_record.follower_count,
          name: db_record.name,
          user_page: db_record.user_page
        )
      end

      def self.db_find_or_create(entity)
        Database::ExpertOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
