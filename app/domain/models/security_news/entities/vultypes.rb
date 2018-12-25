# frozen_string_literal: true

require 'dry-struct'
require_relative 'vultype.rb'
module SMS
  module Entity
    # Model for CVE
    class Vultypes < Dry::Struct
      include Dry::Types.module

      attribute :vultypes, Strict::Array.of(Vultype)

    end
  end
end
