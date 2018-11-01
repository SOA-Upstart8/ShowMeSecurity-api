# frozen_string_literal: true

require 'dry-struct'
require_relative 'tweet.rb'
module SMS
  module Entity
    # Model for CVE
    class CVE < Dry::Struct
      include Dry::Types.module

      attribute :id, Integer.optional
      attribute :overview, Strict::String
      attribute :tweet_count, Strict::Integer
      attribute :references, Strict::Array
      attribute :CVE_ID, Strict::String
      attribute :release_date, Params::DateTime
      attribute :revise_date, Params::DateTime
      attribute :tweets, Strict::Array.of(Tweet)
    end
  end
end
