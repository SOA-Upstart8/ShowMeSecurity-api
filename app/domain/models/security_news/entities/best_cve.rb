# frozen_string_literal: true

require 'dry-struct'
require_relative 'reference.rb'
module SMS
  module Entity
    # Model for CVE
    class BESTCVE < Dry::Struct
      include Dry::Types.module

      attribute :id, Integer.optional
      attribute :type, Strict::Array.of(String)
      attribute :tweet_count, Strict::Integer
      attribute :retweet_count, Strict::Integer
      attribute :references, Strict::Array.of(Reference)
      attribute :CVE_ID, Coercible::String
      attribute :release_date, Params::DateTime
      attribute :affected_product, Strict::Array.of(String)
    end
  end
end
