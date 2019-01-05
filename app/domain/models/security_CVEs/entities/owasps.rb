# frozen_string_literal: true

require 'dry-struct'
require_relative 'Owasp.rb'
module SMS
  module Entity
    # Model for CVE
    class Owasps < Dry::Struct
      include Dry::Types.module

      attribute :owasps, Strict::Array.of(Owasp)
    end
  end
end
