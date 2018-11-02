# frozen_string_literal: true

module SMS
  module Vulnerability
    # Vulnerability for References
    class References
      def self.find_id(id)
        rebuild_entity Database::ReferenceOrm.first(id: id)
      end

      def self.find(entity)
        find_id(entity.id)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Reference.new(
          id:         db_record.id,
          link:       db_record.link
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_ref|
          References.rebuild_entity(db_ref)
        end
      end

      private_class_method :rebuild_entity, :rebuild_many
    end
  end
end
