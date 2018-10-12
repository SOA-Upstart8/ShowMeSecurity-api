require 'http'
require_relative 'news.rb'


module NewsSearch
    class NewsAPI
        module Errors
            class NotFound < StandardError; end
            class Unauthorized < StandardError; end
            class TooManyRequests < StandardError; end
        end

        HTTP_ERROR = {
            401 => Errors::Unauthorized,
            404 => Errors::NotFound,
            429 => Errors::TooManyRequests
        }.freeze

        def initialize(key, cache: {})
            @api_key =  key
            @cache = cache
        end

        def get_news(quary, from, to, source)
            articles = []
            news_url = news_api_path(quary, from, to, source)
            news_response = call_news_url(news_url)
            news = news_response.parse
            news_detail = news['articles']
            news_detail.each {|article| articles << NEWS.new(article)}
            articles
        end

        private 
        
       
        def news_api_path(quary, from, to, source)
            "https://newsapi.org/v2/everything?q=#{quary}&from=#{from}&to=#{to}&sources=#{source}"
        end

        def call_news_url(url)
            result = @cache.fetch(url) do
                HTTP.headers('x-api-key' => @api_key).get(url)
            end
            successful?(result) ? result : raise_error(result)
        end

        def successful?(result)
            HTTP_ERROR.keys.include?(result.code) ? false :true
        end

        def raise_error(result)
            raise(HTTP_ERROR[result.code])
        end
    end
end





