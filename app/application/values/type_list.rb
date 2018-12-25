# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module SMS
  module Value
    # List of Vultypes
    VultypesList = Struct.new(:vultype)
  end
end
