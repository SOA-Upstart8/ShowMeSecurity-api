# frozen_string_literal: true

module NewsSentence
  module CVE
    # Data Mapper: NewsApi data -> News entity
    class TweetMapper
      def self.load_tweets(data)
        data.map { |tweet| TweetMapper.build_entity(tweet) }
      end

      def self.build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Ettract entity specific element from data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          NewsSentence::Entity::Tweet.new(
            id: nil,
            content: content,
            reply_count: reply_count,
            favorite_count: favorite_count,
            retweet_count: retweet_count,
            owner: owner,
            time: time
          )
        end

        private

        def content
          @data['text']
        end

        def reply_count
          @data['reply_count']
        end

        def favorite_count
          @data['favorite_count']
        end

        def retweet_count
          @data['retweet_count']
        end

        def owner
          ExpertMapper.build_entity(@data['user'])
        end

        def time
          @data['@timestamp']
        end
      end
    end
  end
end
