# frozen_string_literal: true

require 'yaml'
require 'fuzzystringmatch'

module SMS
  module Value
    class Overview < SimpleDelegator
      def initialize(overview, category)
        @keywords = YAML.safe_load(File.read(File.join('app/domain/models/security_categories/values', 'keywords.yml')))
        @category = category
        @overview = overview.downcase
        overview_match(overview, category)
      end

      def overview_match(overview, category)
        jarow = FuzzyStringMatch::JaroWinkler.create(:native)
        keyword = get_keyword(category)
        overview = overview.split(' ')
        overview.each do |word|
          keyword.each do |key|
            score = jarow.getDistance(word, key)
            return true if score > 0.7
          end
        end
      end

      def get_keyword(category)
        @keywords[category]
      end
    end
  end
end
