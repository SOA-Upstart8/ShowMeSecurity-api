# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module SMS
  module Value
    # List of months
    MonthsList = Struct.new(:months)
  end
end
