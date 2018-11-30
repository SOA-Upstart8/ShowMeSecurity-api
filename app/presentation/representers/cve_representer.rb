# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module SMS
  module Representer
    class CVE < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      property :cve_id
      property :overview
      property :date

      link :self do
        "#{Api.config.API_HOST}/cves/#{query}"
      end
    end
  end
end
