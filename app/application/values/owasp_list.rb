# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module SMS
  module Value
    # List of CVEs
    OwaspsList = Struct.new(:owasp)
  end
end
