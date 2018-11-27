# frozen_string_literal: true

require 'dry-validation'

module SMS
  module Forms
    Query = Dry::Validation.Params do
      QUERY_REGEX = %r{(?:\/|"|\\|;|<|>|\=|%)+}.freeze

      required(:query).filled(format?: QUERY_REGEX)
    end
  end
end
