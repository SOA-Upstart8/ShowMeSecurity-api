# frozen_string_literal: true

require 'yaml'
require 'fuzzystringmatch'

module SMS
  module Value
    class Overview < SimpleDelegator
      def initialize(overview, category)
<<<<<<< HEAD
        @keywords = YAML.safe_load(File.open('keywords.yml'))
        puts @keywords
=======
        @keywords = YAML.safe_load(File.read(File.join('app/domain/security_categories/values', 'keywords.yml')))
>>>>>>> 3097c84fe488955f949aa4c7550c035513ae5286
        @category = category
        @overview = overview.downcase
        overview_match(overview, category)
      end

      def overview_match(overview, category)
        jarow = FuzzyStringMatch::JaroWinkler.create( :native )
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
