# frozen_string_literal: true

module SMS
  module Mapper
    class CVEMapper
      def initialize(query)
        @cve_array = SMS::CVE::CVEMapper.new(SMS::App.config.SEC_API_KEY).search(query)
      end

      def filter
        Entity::CVE_ARR.new(cve_array, query)
      end

    end
  end
end
