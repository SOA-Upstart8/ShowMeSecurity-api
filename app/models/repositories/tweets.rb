# frozen_string_literal: true

module SMS
  module Repository
    # Repository for Tweets
    class Tweets
      def self.find_id(id)
        rebuild_entity Database::TweetOrm.first(id: id)
      end

      def self.find(entity)
        rebuild_entity Database::TweetOrm.first(content: entity.content)
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_tweet|
          rebuild_entity(db_tweet)
        end
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Tweet.new(
          id:             db_record.id,
          content:        db_record.content,
          reply_count:    db_record.reply_count,
          favorite_count: db_record.favorite_count,
          retweet_count:  db_record.retweet_count,
          time:           db_record.time,
          owner_id:       db_record.owner_id,
          owner_image:    db_record.owner_image,
          owner_name:     db_record.owner_name,
          owner_page:     db_record.owner_page
        )
      end
      private_class_method :rebuild_entity
    end
  end
end
