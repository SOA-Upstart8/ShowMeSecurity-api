# frozen_string_literal: false

require 'http'
module SMS
  module News
    # The NewsAPI class is responsible for get news detail.
    class Api
      def initialize(key)
        @api_key = key
      end

      def get_news(query, from, to, source)
        Request.new(@api_key).news(query, from, to, source).parse
      end

      def get_headlines(country)
        Request.new(@api_key).headlines(country).parse
      end

      # The Request class is responsible for send a http request.
      class Request
        PATH = 'https://newsapi.org/v2/everything'.freeze
        HEADLINES = 'https://newsapi.org/v2/top-headlines'.freeze

        def initialize(key)
          @api_key = key
        end

        def news(quary, from, to, source)
          get(PATH + "?q=#{quary}&from=#{from}&to=#{to}&sources=#{source}")
        end

        def headlines(country)
          get(HEADLINES + "?country=#{country}")
        end

        def get(url)
          result = HTTP.headers('x-api-key' => @api_key).get(url)
          Response.new(result).tap do |response|
            raise(response.raise_error) unless response.successful?
          end
        end
      end

      # The Response class is responsible for error requests.
      class Response < SimpleDelegator
        # Unauthorized is responsible for no access key.
        Unauthorized = Class.new(StandardError)
        # TooOldNews is responsible for rejecting to access 30 days ago news.
        TooOldNews = Class.new(StandardError)

        HTTP_ERROR = {
          401 => Unauthorized,
          429 => TooOldNews
        }.freeze

        def successful?
          HTTP_ERROR.key?(code) ? false : true
        end

        def raise_error
          HTTP_ERROR[code]
        end
      end
    end
  end
end
