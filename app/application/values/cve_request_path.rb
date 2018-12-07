# frozen_string_literal: true

module SMS
    module RouteHelpers
      # Application value for the path of a requested cve
      class CVERequestPath
        def initialize(query)
          @query = query
        end
  
        attr_reader :query
      end
    end
  end