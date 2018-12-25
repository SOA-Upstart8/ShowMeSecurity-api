# frozen_string_literal: true

module SMS
  module CVE
    # Data Mapper: NewsApi data -> News entity
    class VulMapper
      def initialize(api_key, gateway_class = CVE::Api)
        @api_key = api_key
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@api_key)
      end

      def best
        data = @gateway.best_cve
        data = data['stat']
        puts data
        t1 = vultype(data['_vulTypeAgg'])
        t1
      end

      def vultype(data)
        data.map do |type|
          BestMapper.build_entity(type)
        end
      end

      def self.build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Ettract entity specific element from data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          SMS::Entity::Vultype.new(
            id: nil,
            type: type,
            number: number
          )
        end

        private

        def type
          @data['label']
        end

        def number
          @data['data']
        end
      end
    end
  end
end
