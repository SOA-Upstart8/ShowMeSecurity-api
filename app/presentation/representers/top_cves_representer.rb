# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'top_cve_representer'

module SMS
  module Representer
    # Represents list of cves for API output
    class TopCVEsList < Roar::Decorator
      include Roar::JSON

      collection :cves, extend: Representer::TopCVE, class: OpenStruct
    end
  end
end
