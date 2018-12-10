# frozen_string_literal: true

require 'dry-struct'
require_relative 'CVE.rb'
module SMS
  module Entity
    # Model for CVE
    class CVEs < Dry::Struct
      include Dry::Types.module

      attribute :cves, Strict::Array.of(CVE)

    end
  end
end
