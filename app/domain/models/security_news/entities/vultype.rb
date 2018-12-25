# frozen_string_literal: true

require 'dry-struct'

module SMS
  module Entity
    # Model for Type
    class Vultype < Dry::Struct
      include Dry::Types.module

      attribute :id, Integer.optional
      attribute :type, Strict::String
      attribute :number, Strict::Integer
    end
  end
end
