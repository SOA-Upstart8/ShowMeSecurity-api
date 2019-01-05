# frozen_string_literal: true

require 'dry-struct'
require_relative 'best_cve.rb'
module SMS
  module Entity
    # Model for CVE
    class BESTCVEs < Dry::Struct
      include Dry::Types.module

      attribute :cves, Strict::Array.of(BESTCVE)

    end
  end
end
