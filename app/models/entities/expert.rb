# frozen_string_literal: true

require 'dry-struct'

module NewsSentence
  module Entity
    # Model for expert
    class Expert < Dry::Struct
      include Dry::Types.module

      attribute :user_id, Strict::Integer
      attribute :image, Strict::String
      attribute :follower_count, Strict::Integer
      attribute :name, Strict::String
      attribute :user_page, Strict::String
    end
  end
end
