# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module SMS
  module Representer
    class CVE < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      property :CVE_ID
      property :overview
      property :release_date

      private

      def cve_id
        represented.CVE_ID
      end

      def overview
        represented.overview
      end

      def date
        represented.release_date
      end
    end
  end
end
