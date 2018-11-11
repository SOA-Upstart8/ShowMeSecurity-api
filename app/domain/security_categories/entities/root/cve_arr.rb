# frozen_string_literal: true

require 'dry-struct'

module SMS
  module Entity
    # Model for CVE
    class CVE_ARR

      attr_reader :cve_array, :size, :category

      def initialize(cve_array:, category:)
        @cve_array = cve_array
        @size = cve_array.length
        @category = category
      end

      def filter
        match_array = []
        cve_array.each do |cve|
          cve_match = CVEMatch.new(cve.overview, category).match
          match_array << cve if cve_match == 1
        end
      end

    end
  end
end
