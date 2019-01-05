# frozen_string_literal: false

require 'http'

module SMS
  module CVE
    # The SECAPI class is responsible for get CVEs detail.
    class Api
      def initialize(key)
        @api_key = key
      end

      # return the latest CVE
      def latest_cve
        Request.new(@api_key).latest.parse
      end

      # return CVE related to the vulname
      def search_owasp(vulname)
        Request.new(@api_key).owasp(vulname).parse
      end

      # search CVE by user's query
      def search_cve(query)
        Request.new(@api_key).search(query).parse
      end

      # search CVE by CVE_ID
      def find_by_cveid(cve_id)
        Request.new(@api_key).find_cve_id(cve_id).parse
      end

      # return top 5 CVE info
      def best_cve
        Request.new(@api_key).best.parse
      end

      # return number of every month CVEs
      def get_every_month(from, to)
        Request.new(@api_key).every_month(from, to).parse
      end

      # The Request class is responsible for send a http request.
      class Request
        LATEST_PATH = 'https://api.sb.cyber00rn.org/api/vulnerability/?fields=tweet&X-API-KEY='.freeze
        SEARCH_PATH = 'https://api.sb.cyber00rn.org/api/vulnerability/search?'.freeze
        BEST_PATH = 'https://api.sb.cyber00rn.org/api/vulnerability/top/5?time_to=2018-12-31&time_from=2018-01-01&X-API-KEY='.freeze
        MONTH_PATH = 'https://api.sb.cyber00rn.org/api/vulnerability/top/1?'.freeze
        FIND_ID_PATH = 'https://api.sb.cyber00rn.org/api/vulnerability/'.freeze
        def initialize(key)
          @api_key = key
        end

        def latest
          get(LATEST_PATH + @api_key)
        end

        def owasp(query)
          get(SEARCH_PATH +
            "q=#{query}&size=100&fields=tweet&X-API-KEY=" + @api_key)
        end

        def search(query)
          get(SEARCH_PATH +
            "q=#{query}&size=20&fields=tweet&X-API-KEY=" + @api_key)
        end

        def find_cve_id(cve_id)
          get(FIND_ID_PATH +
            "#{cve_id}?fields=tweet&X-API-KEY=" + @api_key)
        end

        def best
          get(BEST_PATH + @api_key)
        end

        def every_month(from, to)
          get(MONTH_PATH +
            "time_to=#{to}&time_from=#{from}&size=100&X-API-KEY=" + @api_key)
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
        Unauthorized = Class.new(StandardError)
        InvalidCredential = Class.new(StandardError)
        LimitExceeded = Class.new(StandardError)
        NoContent = Class.new(StandardError)

        HTTP_ERROR = {
          204 => NoContent,
          401 => Unauthorized,
          403 => InvalidCredential,
          404 => NotFound,
          429 => LimitExceeded
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
