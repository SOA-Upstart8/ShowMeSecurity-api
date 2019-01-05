# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module SMS
  module Entity
    class CVEMatch
      IS_MATCH = 1
      NOT_MATCH = 0

      def initialize(overview, category)
        @overview = overview
        @category = category
      end

      def match
        useful? ? IS_MATCH : NOT_MATCH
      end

      def useful?
        Value::Overview.new(@overview, @category).overview_filter
      end
    end
  end
end
