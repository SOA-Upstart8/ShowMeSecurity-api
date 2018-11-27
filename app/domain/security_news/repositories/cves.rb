# frozen_string_literal: true

module SMS
  module Repository
    # Repository for CVEs
    class CVEs
      def self.all
        Database::CVEOrm.all.map { |db_cve| rebuild_entity(db_cve) }
      end

      def self.find_list_id(list)
        list.map do |cve_id|
          find_cve_id(cve_id)
        end
      end

      def self.find_id(id)
        rebuild_entity Database::CVEOrm.first(id: id)
      end

      def self.find_cve_id(cve_id)
        rebuild_entity Database::CVEOrm.first(CVE_ID: cve_id)
      end

      def self.create(entity)
        return if find_cve_id(entity.CVE_ID)
        
        db_cve = PersistCVE.new(entity).call
        rebuild_entity(db_cve)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::CVE.new(
          db_record.to_hash.merge(
            references: References.rebuild_many(db_record.references),
            tweets: Tweets.rebuild_many(db_record.tweets)
          )
        )
      end

      private_class_method :rebuild_entity

      # Helper class to persist CVE and its tweets and references to database
      class PersistCVE
        def initialize(entity)
          @entity = entity
        end

        def create_cve
          Database::CVEOrm.create(@entity.to_attr_hash)
        end

        def call
          create_cve.tap do |db_cve|
            @entity.references.each do |ref|
              db_cve.add_reference(Database::ReferenceOrm.create(ref.to_attr_hash))
            end
            @entity.tweets.each do |tweet|
              db_cve.add_tweet(Database::TweetOrm.create(tweet.to_attr_hash))
            end
          end
        end
      end
    end
  end
end
