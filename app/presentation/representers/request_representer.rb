# frozen_string_literal: true


# Represents essential Repo information for API output
module SMS
  module Representer
    # Representer object for project clone requests
    class Request < Roar::Decorator
      include Roar::JSON

      property :category
      property :request_id
    end
  end
end
