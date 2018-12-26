# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'references_representer.rb'
require_relative 'tweet_representer.rb'

module SMS
  module Representer
    # Represents list of cves for API output
    class CVE_detail < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      property :CVE_ID
      property :overview
      property :release_date
      property :zeroday_price
      property :vultype
      property :affected_product
      property :affected_vendor
      collection :references, extend: Representer::Reference, class: OpenStruct
      collection :tweets, extend: Representer::Tweet, class: OpenStruct
    end
  end
end
