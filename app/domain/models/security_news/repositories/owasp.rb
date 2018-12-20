# frozen_string_literal: true

module SMS
  module Repository
    # Repository for Owasps
    class Owasps
      def self.all
        Database::OwaspOrm.all.map { |db_cve| rebuild_entity(db_cve) }
      end

      def self.find_list_id(list)
        list.map do |cve_id|
          find_cve_id(cve_id)
        end
      end

      def self.truncate
        Database::OwaspOrm.truncate
      end

      def self.find_category(owasp)
        Database::OwaspOrm.where(category: owasp)
          .map { |db_cve| rebuild_entity(db_cve) }
      end

      def self.find_category_count(owasp)
        Database::OwaspOrm.where(category: owasp).count
      end

      def self.find_id(id)
        rebuild_entity Database::OwaspOrm.first(id: id)
      end

      def self.find_cve_id(cve_id)
        rebuild_entity Database::OwaspOrm.first(CVE_ID: cve_id)
      end

      def self.create(entity)
        return if find_cve_id(entity.CVE_ID)

        db_cve = PersistOwasp.new(entity).call
        rebuild_entity(db_cve)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Owasp.new(
          db_record.to_hash.merge(
            references: OwaspRefs.rebuild_many(db_record.owasp_refs)
          )
        )
      end

      private_class_method :rebuild_entity

      # Helper class to persist CVE and its references to database
      class PersistOwasp
        def initialize(entity)
          @entity = entity
        end

        def create_cve
          Database::OwaspOrm.create(@entity.to_attr_hash)
        end

        def call
          create_cve.tap do |db_cve|
            @entity.references.each do |ref|
              db_cve.add_owasp_ref(Database::OwaspRefOrm.create(ref.to_attr_hash))
            end
          end
        end
      end
    end
  end
end
