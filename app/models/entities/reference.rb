# frozen_string_literal: true

require 'dry-struct'

module SMS
  module Entity
    # Model for expert
    class Reference < Dry::Struct
      include Dry::Types.module

      attribute :id, Integer.optional
      attribute :link, Strict::String

      def to_attr_hash
        to_hash.reject { |key, _| [:id].include? key }
      end
    end
  end
end
