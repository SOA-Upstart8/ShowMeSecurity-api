# frozen_string_literal: true

require 'yaml'
require 'amatch'

module SMS
  module Value
    # Filter CVE by their overview
    class Overview < SimpleDelegator
      include Amatch
      def initialize(overview, category)
        path = 'app/domain/models/security_owasp/values'
        @keywords = YAML.safe_load(File.read(File.join(path, 'keywords.yml')))
        @category = category
        @overview = overview.downcase
      end

      def overview_filter
        keyword = get_keyword(@category)
        overview = @overview.split(' ')
        overview.each do |word|
          jarow = JaroWinkler.new(word)
          keyword.each do |key|
            score = jarow.match(key)
            return true if score > 0.7
          end
        end
        false
      end

      def get_keyword(category)
        @keywords[category]
      end
    end
  end
end
