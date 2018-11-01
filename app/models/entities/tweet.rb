# frozen_string_literal: true

require 'dry-struct'
require_relative 'expert.rb'
module SMS
  module Entity
    # Model for tweet
    class Tweet < Dry::Struct
      include Dry::Types.module

      attribute :id, Integer.optional
      attribute :content, Strict::String
      attribute :reply_count, Strict::Integer
      attribute :favorite_count, Strict::Integer
      attribute :retweet_count, Strict::Integer
      attribute :owner, Expert
      attribute :time, Params::DateTime
    end
  end
end
