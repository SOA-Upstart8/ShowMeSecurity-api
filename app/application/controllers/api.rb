# frozen_string_literal: true

require 'roda'

module SMS
  # Web Api
  class Api < Roda
    include RouteHelpers

    plugin :halt
    plugin :all_verbs
    plugin :caching
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
              Representer::CVEsList.new(result.value!.message).to_json
            end
          end

          routing.on String do |category|
            # GET /cves/{category}
            routing.get do
              response.cache_control public: true, max_age: 30

              request_id = [request.env, request.path, Time.now.to_f].hash

              result = Service::CVEOwasp.new.call(
                category: category,
                request_id: request_id
              )

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end
              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              owasps = result.value!.message
              cve_list = Entity::Owasps.new(owasps: owasps)
              Representer::OwaspsList.new(cve_list).to_json
            end
          end
        end

        routing.on 'search' do
          routing.on String do |query|
            # GET /search/{query}
            routing.get do
              response.cache_control public: true, max_age: 30
              result = Service::CVESearch.new.call(query)

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              cves = result.value!.message
              cve_list = Entity::CVEs.new(cves: cves)
              Representer::CVEsList.new(cve_list).to_json
            end
          end
        end

        routing.on 'latest' do
          routing.is do
            # GET /latest
            routing.get do
              response.cache_control public: true, max_age: 30
              result = Service::CVELatest.new.call

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              cves = result.value!.message
              cve_list = Entity::CVEs.new(cves: cves)
              Representer::CVEsList.new(cve_list).to_json
            end
          end
        end

        routing.on 'analysis' do
          routing.on String do |_month|
            # GET /analysis/month
            routing.get do
              response.cache_control public: true, max_age: 30
              result = Service::CVEOrderMonth.new.call

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              result_month = Value::MonthsList.new(result.value!.message)
              Representer::MonthsList.new(result_month).to_json
            end
          end
        end

        routing.on 'top_5' do
          routing.is do
            # GET /top_5
            routing.get do
              response.cache_control public: true, max_age: 30
              result = Service::CVETop.new.call

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              cves = result.value!.message
              cve_list = Entity::BESTCVEs.new(cves: cves)
              Representer::TopCVEsList.new(cve_list).to_json
            end
          end
        end

        routing.on 'vultype' do
          routing.is do
            # GET /vultype
            routing.get do
              response.cache_control public: true, max_age: 30
              result = Service::Vultype.new.call

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              vultypes = result.value!.message
              type_list = Entity::Vultypes.new(vultypes: vultypes)
              Representer::VultypesList.new(type_list).to_json
            end
          end
        end
      end
    end
  end
end
