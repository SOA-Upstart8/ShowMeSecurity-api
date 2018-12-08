# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module SMS
  module Value
    # List of CVEs
    CVEList = Struct.new(:CVEs)
  end
end
