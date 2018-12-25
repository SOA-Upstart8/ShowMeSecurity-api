# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'type_representer.rb'

module SMS
  module Representer
    # Represents list of cves for API output
    class VultypesList < Roar::Decorator
      include Roar::JSON

      collection :vultypes, extend: Representer::Vultype, class: OpenStruct
    end
  end
end
