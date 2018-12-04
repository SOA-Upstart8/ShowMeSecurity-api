# frozen_string_literal: true

require 'roda'

module SMS
  # Web App
  class Api < Roda
    include RouteHelpers

    plugin :halt
    plugin :all_verbs
    use Rack::MethodOverride

    route do |routing|
      response['Content-Type'] = 'application/json'

      # GET /
      routing.root do
        message = "SMS API v1 at /api/v1/ in #{Api.environment} mode"

        result_response = Representer::HttpResponse.new(
          Value::Result.new(status: :ok, message: message)
        )

        response.status = result_response.http_status_code
        result_response.to_json
      end

      routing.on 'api/v1' do
        routing.on 'cves' do
          routing.is do
            # GET /cves?query={base64 json array of cve}
            routing.get do
              result = Service::CVEList.new.call(
                query_request: Value::QueryRequest.new(routing.params)
              )

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              Representer::CVEsList.new(result.value!.message).to_json
            end
          end
        end
      end
    end
  end
end