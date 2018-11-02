# frozen_string_literal: true

module SMS
  module Database
    # Object Relational Mapper for News Entities
    class NewsOrm < Sequel::Model(:news)
      plugin :timestamps, update_on_create: true

      def self.find_or_create(news_info)
        first(url: news_info[:url]) || create(news_info)
      end
    end
  end
end
