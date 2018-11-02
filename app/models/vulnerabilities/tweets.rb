# frozen_string_literal: true

module SMS
  module Vulnerability
    # Vulnerability for Tweets
    class Tweets
      def self.find_id(id)
        rebuild_entity Database::TweetOrm.first(id: id)
      end

      def self.find(entity)
        rebuild_entity Database::TweetOrm.first(content: entity.content)
      end

      # create tweet_db data and expert_db data
      def self.create(entity)
        raise 'Tweet already exists' if find(entity)

        db_tweet = PersistTweet.new(entity).call
        rebuild_entity(db_tweet)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Tweet.new(
          db_record.to_hash.merge(
            owner: Experts.rebuild_entity(db_record.owner)
          )
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_tweet|
          Tweets.rebuild_entity(db_tweet)
        end
      end

      private_class_method :rebuild_entity, :rebuild_many

      # Helper class to persist tweet and its owner to database
      class PersistTweet
        def initialize(entity)
          @entity = entity
        end

        def create_tweet
          Database::TweetOrm.create(@entity.to_attr_hash)
        end

        def call
          owner = Experts.db_find_or_create(@entity.owner)
          create_tweet.tap do |db_tweet|
            db_tweet.update(owner: owner)
          end
        end
      end
    end
  end
end
