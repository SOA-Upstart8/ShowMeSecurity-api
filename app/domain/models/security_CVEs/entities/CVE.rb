# frozen_string_literal: true

require 'dry-struct'
require_relative 'tweet.rb'
require_relative 'reference.rb'
module SMS
  module Entity
    # Model for CVE
    class CVE < Dry::Struct
      include Dry::Types.module

      attribute :id, Integer.optional
      attribute :overview, Strict::String
      attribute :vultype, Strict::String
      attribute :zeroday_price, Coercible::String
      attribute :affected_product, Strict::String
      attribute :affected_vendor, Strict::String
      attribute :tweet_count, Strict::Integer
      attribute :references, Strict::Array.of(Reference)
      attribute :CVE_ID, Coercible::String
      attribute :release_date, Params::DateTime
      attribute :revise_date, Params::DateTime
      attribute :tweets, Strict::Array.of(Tweet)

      def to_attr_hash
        to_hash.reject { |key, _| %i[id references tweets].include? key }
      end
    end
  end
end
