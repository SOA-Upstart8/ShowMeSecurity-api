# frozen_string_literal: true

module SMS
  module News
    # Data Mapper: NewsApi data -> News entity
    class NewsMapper
      def initialize(api_key, gateway_class = News::Api)
        @api_key = api_key
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@api_key)
      end

      def search(query, from, to, source)
        data = @gateway.get_news(query, from, to, source)
        data = data['articles']
        data.map do |news|
          NewsMapper.build_entity(news)
        end
      end

      def search_headlines(country)
        data = @gateway.get_headlines(country)
        puts 'data'
        data = data['articles']
        data.map do |news|
          NewsMapper.build_entity(news)
        end
      end

      def self.build_entity(data)
        DataMapper.new(data).build_entity
      end
    end

    # Ettract entity specific element from data structure
    class DataMapper
      def initialize(data)
        @data = data
      end

      def build_entity
        SMS::Entity::News.new(
          id: nil,
          source: source,
          title: title,
          url: url,
          image: image,
          time: time,
          content: content
        )
      end

      private

      def source
        @data['source']['name']
      end

      def title
        @data['title']
      end

      def url
        @data['url']
      end

      def image
        @data['urlToImage']
      end

      def time
        @data['publishedAt']
      end

      def content
        @data['content']
      end
    end
  end
end
