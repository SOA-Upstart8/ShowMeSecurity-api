# frozen_string_literal: true

module NewsSentence
  module Court
    # Data Mapper: NewsApi data -> News entity
    class CourtMapper
      def initialize(gateway_class = Court::Api)
        @gateway_class = gateway_class
        @gateway = @gateway_class.new
      end

      def search(page, type, year)
        data = @gateway.get_stories(page, type, year)
        data = data['stories']
        data.map do |story|
          CourtMapper.build_entity(story)
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
        NewsSentence::Entity::Story.new(
          id: nil,
          type: type,
          year: year,
          word: word,
          number: number,
          reason: reason,
          parties_name: parties_name,
          court: court,
          detail_url: detail_url
        )
      end

      private

      def type
        @data['identity']['type']
      end

      def year
        @data['identity']['year']
      end

      def word
        @data['identity']['word']
      end

      def number
        @data['identity']['number']
      end

      def reason
        @data['reason']
      end

      def parties_name
        @data['parties_name']
      end

      def court
        @data['court']['name']
      end

      def detail_url
        @data['detail_url']
      end
    end
  end
end
