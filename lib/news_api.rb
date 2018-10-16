require 'http'
require_relative 'news.rb'


module NewsSearch
    class NewsAPI
        # module Errors
        #     class Unauthorized < StandardError; end
        #     class TooManyRequests < StandardError; end
        # end
        #
        # HTTP_ERROR = {
        #     401 => Errors::Unauthorized,
        #     429 => Errors::TooManyRequests
        # }.freeze

        # def initialize(key, cache: {})
        #     @api_key =  key
        #     @cache = cache
        # end

        # def get_news(quary, from, to, source)
        #     articles = []
        #     news_url = news_api_path(quary, from, to, source)
        #     news_response = call_news_url(news_url)
        #     news = news_response.parse
        #     news_detail = news['articles']
        #     news_detail.each {|article| articles << NEWS.new(article)}
        #     articles
        # end

        def initialize(key)
            @api_key = key
        end

        def get_news(query, from, to, source)
            articles = []
            news_response = Request.new(@api_key)
                                .news(query, from, to, source)
            news = news_response.parse
            news_detail = news['articles']
            news_detail.each {|article| articles << NEWS.new(article)}
            articles
        end

        private 
        
       
        # def news_api_path(quary, from, to, source)
        #     "https://newsapi.org/v2/everything?q=#{quary}&from=#{from}&to=#{to}&sources=#{source}"
        # end
        #
        # def call_news_url(url)
        #     result = @cache.fetch(url) do
        #         HTTP.headers('x-api-key' => @api_key).get(url)
        #     end
        #     successful?(result) ? result : raise_error(result)
        # end
        #
        # def successful?(result)
        #     HTTP_ERROR.keys.include?(result.code) ? false :true
        # end
        #
        # def raise_error(result)
        #     raise(HTTP_ERROR[result.code])
        # end

        class Request
            api_path = '"https://newsapi.org/v2/everything'

            def initialize(key, cache: {})
                @api_key =  key
                @cache = cache
            end

            def news(quary, from, to, source)
                get(api_path + "?q=#{quary}&from=#{from}&to=#{to}&sources=#{source}")
            end

            def get(url)
                result = @cache.fetch(url) do
                    HTTP.headers('x-api-key' => @api_key).get(url)
                end
                Response.new(result).tap do |response|
                  raise(response.raise_error) unless response.successful?
                end
                # successful?(result) ? result : raise_error(result)
            end
        end

        class Response < SimpleDelegator
            Unauthorized =  Class.new(StandardError)
            TooManyRequests = Class.new(StandardError)

            HTTP_ERROR = {
                401 => Errors::Unauthorized,
                429 => Errors::TooManyRequests
            }.freeze

            def successful?(result)
                HTTP_ERROR.keys.include?(result.code) ? false :true
            end

            def raise_error(result)
                raise(HTTP_ERROR[result.code])
            end
        end
    end
end





