# frozen_string_literal: true

require 'yaml'
require 'amatch'
include Amatch

module SMS
  module Value
    class Overview < SimpleDelegator
      def initialize(overview, category)
        @keywords = YAML.safe_load(File.read(File.join('app/domain/models/security_categories/values', 'keywords.yml')))
        @category = category
        @overview = overview.downcase
      end

      def overview_match
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
