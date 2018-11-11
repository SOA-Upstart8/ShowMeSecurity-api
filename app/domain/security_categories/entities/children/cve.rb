# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module SMS
  module Entity
    class CVEMatch
      IS_MATCH = 1
      NOT_MATCH = 0

      attr_reader :overview, :category

      def initialize(overview:, category:)
        @overview = Value::Overview.new(overview, category)
      end

      def match
        useful? ? IS_MATCH : NOT_MATCH
      end

      def useful?
        Value::Overview.new(overview, category)
      end

    end
  end
end
