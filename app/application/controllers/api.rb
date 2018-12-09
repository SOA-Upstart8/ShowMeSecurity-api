# frozen_string_literal: true

require 'roda'

module SMS
  # Web Api
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
            # GET /cves
            routing.get do
              result = Service::CVEList.new.call

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code

              cves_arr = result.value!.message[0]
              cves = cves_arr[1]

              Representer::CVE.new(cves).to_json
            end
          end

          routing.on String do |category|
            # GET /cves/{category}
            routing.get do
              result = Service::CVEOwasp.new.call(category)

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              cves = result.value!.message[0]

              Representer::CVE.new(cves).to_json
            end
          end
        end
      end
    end
  end
end
