# frozen_string_literal: false

require 'http'
module NewsSentence
  module Court
    # The NewsAPI class is responsible for get news detail.
    class Api
      def initialize()end

      def get_stories(page, type, year)
        Request.new.stories(page, type, year).parse
      end

      # The Request class is responsible for send a http request.
      class Request
        PATH = 'https://api.jrf.org.tw/search/stories?'.freeze

        def initialize()end

        def stories(page, type, year)
          get(PATH + "page=#{page}&q[story_type]=#{type}&q[year]=#{year}")
        end

        def get(url)
          result = HTTP.get(url)
          Response.new(result).tap do |response|
            raise(response.raise_error) unless response.successful?
          end
        end
      end

      # The Response class is responsible for error requests.
      class Response < SimpleDelegator
        NotFound = Class.new(StandardError)

        HTTP_ERROR = {
          404 => NotFound
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
