# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'top_cve_representer'
require_relative 'references_representer.rb'

module SMS
  module Representer
    # Represents list of cves for API output
    class TopCVE < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      property :CVE_ID
      property :type
      property :release_date
      property :tweet_count
      property :retweet_count
      property :affected_product
      collection :references, extend: Representer::Reference, class: OpenStruct
    end
  end
end
