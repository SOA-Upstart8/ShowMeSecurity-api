# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module SMS
  module Value
    # Struct of months
    Month = Struct.new(:date, :number)
  end
end
