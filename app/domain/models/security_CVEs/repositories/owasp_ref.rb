# frozen_string_literal: true

module SMS
  module Repository
    # Repository for References
    class OwaspRefs
      def self.find_id(id)
        rebuild_entity Database::OwaspRefOrm.first(id: id)
      end

      def self.find(entity)
        rebuild_entity Database::OwaspRefOrm.first(link: entity.link)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::OwaspRef.new(
          id: db_record.id,
          link: db_record.link
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_ref|
          rebuild_entity(db_ref)
        end
      end

      private_class_method :rebuild_entity
    end
  end
end
