# frozen_string_literal: true

module SMS
  module Mapper
    class CVEMapper
      def initialize(query)
        @query = query
        @cve_array = SMS::CVE::CVEMapper.new(SMS::Api.config.SEC_API_KEY).search(@query)
      end

      def filter
        Entity::CVE_ARR.new(@cve_array, @query).filter_match
      end
    end
  end
end
