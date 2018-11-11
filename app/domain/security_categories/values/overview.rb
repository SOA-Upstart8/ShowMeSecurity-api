# frozen_string_literal: true
require 'yaml'

module SMS
  module Value
    class Overview < SimpleDelegator
      keyword = YAML.safe_load('keywords.yml')

      def initialize(overview, category)
        @category = category
        @overview = overview.downcase
        overview_match(overview)
      end

      def overview_match(overview)
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
        keyword[category]
      end

    end
  end
end