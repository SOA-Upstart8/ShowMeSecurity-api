# frozen_string_literal: true

require 'dry-struct'

module NewsSentence
  module Entity
    # Model for cnn
    class Story < Dry::Struct
      include Dry::Types.module

      attribute :id, Integer.optional
      attribute :type, Strict::String
      attribute :year, Strict::Integer
      attribute :word, Strict::String
      attribute :number, Strict::Integer
      attribute :reason, String.optional
      attribute :parties_name, String.optional
      attribute :court, Strict::String
      attribute :detail_url, Strict::String
    end
  end
end
