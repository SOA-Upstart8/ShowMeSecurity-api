# frozen_string_literal: true

require 'dry-struct'

module NewsSentence
  module Entity
    # Model for cnn
    class News < Dry::Struct
      include Dry::Types.module

      attribute :id, Integer.optional
      attribute :source, Strict::String
      attribute :title, Strict::String
      attribute :url, Strict::String
      attribute :image, Strict::String
      attribute :time, Strict::String
      attribute :content, Strict::String
    end
  end
end
