# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module SMS
  module Value
    Request = Struct.new(:category, :request_id)
  end
end
