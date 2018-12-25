# frozen_string_literal: true

module SMS
  module CVE
    # Data Mapper: NewsApi data -> News entity
    class BestMapper
      def initialize(api_key, gateway_class = CVE::Api)
        @api_key = api_key
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@api_key)
      end

      def best
        data = @gateway.best_cve
        data = data['top']
        t1 = price(data['_topPrice'])
        t2 = popular(data['_topPopular'])
        t3 = severity(data['_topSeverity'])
        t1 + t2 + t3
      end

      def popular(data)
        data.map do |cve|
          BestMapper.build_entity(cve)
        end
      end

      def price(data)
        data.map do |cve|
          BestMapper.build_entity(cve)
        end
      end

      def severity(data)
        data.map do |cve|
          BestMapper.build_entity(cve)
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
          SMS::Entity::BESTCVE.new(
            id: nil,
            type: type,
            tweet_count: tweet_count,
            references: references,
            CVE_ID: cve_id,
            release_date: release_date,
            affected_product: affected_product,
            retweet_count: retweet_count
          )
        end

        private

        def type
          @data['vultype'] = [] if @data['vultype'].nil?
          @data['vultype']
        end

        def tweet_count
          @data['tweet_count']
        end

        def retweet_count
          @data['retweet_count']
        end

        def references
          ReferenceMapper.load_references(@data['references'])
        end

        def cve_id
          @data['CVE_ID']
        end

        def release_date
          @data['original_release_date']
        end

        def affected_product
          @data['affected_product'] = [] if @data['affected_product'].nil?
          @data['affected_product']
        end
      end
    end
  end
end
