# frozen_string_literal: true

require 'dry-struct'

module SMS
  module Entity
    # Model for cnn
    class News < Dry::Struct
      include Dry::Types.module

      attribute :id, Integer.optional
      attribute :source, String.optional
      attribute :title, String.optional
      attribute :url, String.optional
      attribute :image, String.optional
      attribute :time, String.optional
      attribute :content, String.optional

      def to_attr_hash
        to_hash.reject { |key, _| [:id].include? key }
      end
    end
  end
end
