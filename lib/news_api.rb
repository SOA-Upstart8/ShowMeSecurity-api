require 'http'
require_relative 'bbc.rb'
require_relative 'cnn.rb'

module CodePraise
    class NewsAPI
        module Errors
            class NotFound < StandardError; end
            class Unauthorized < StandardError; end
        end

        HTTP_ERROR = {
            401 => Errors::Unauthorized,
            404 => Errors::NotFound
        }.freeze

        def initialize(key, cache: {})
            @api_key =  key
            @cache = cache
        end

        def cnn(path)
            array = []
            news_url = news_api_path(path,'cnn')
            news_response = call_news_url(news_url)
            news = news_response.parse
            news_detail = news['articles']
            news_detail.each {|report| array << CNN.new(report)}
            array
        end

        def bbc(path)
            array = [] 
            news_url = news_api_path(path,'bbc-news')
            news_response = call_news_url(news_url)
            news = news_response.parse
            news_detail = news['articles']
            news_detail.each {|report| array << BBC.new(report)}
            array
        end
        
        private 
        
       
        def news_api_path(path, name)
            'https://newsapi.org/v2/' + path + name
        end

        def call_news_url(url)
            result = @cache.fetch(url) do
                HTTP.headers(
                    'x-api-key' => @api_key).get(url)
            end
            successful?(result) ? result : raise_error(result)
        end

        def successful?(result)
            HTTP_ERROR.keys.include?(result.code) ? false :true
        end
    end
end





