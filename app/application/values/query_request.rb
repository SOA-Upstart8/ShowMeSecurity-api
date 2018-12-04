# frozen_string_literal: true

require 'base64'
require 'dry/monads/result'
require 'json'

module SMS
  module Value
    # Query request parser
    class QueryRequest
      include Dry::Monads::Result::Mixin

      def initialize(params)
        @params = params
      end

      # Use in API to parse incoming query requests
      def call
        query = JSON.parse(Base64.urlsafe_decode64(@params['query']))
        Success(query)
      rescue StandardError
        Failure(Value::Result.new(status: :bad_request,
                                  message: 'CVE not found'))
      end

      # Use in client App to create params to send
      def self.to_encoded(query)
        Base64.urlsafe_encode64(query.to_json)
      end

      # Use in tests to create a ListRequest object from a list
      def self.to_request(list)
        ListRequest.new('list' => to_encoded(list))
      end
    end
  end
end
