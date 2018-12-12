# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module SMS
  module Value
    # List of TopCVEs
    TopCVEsList = Struct.new(:BESTCVE)
  end
end
