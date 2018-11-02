# frozen_string_literal: true

module SMS
  module CVE
    # Data Mapper: NewsApi data -> News entity
    class CVEMapper
      def initialize(api_key, gateway_class = CVE::Api)
        @api_key = api_key
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@api_key)
      end

      def latest
        data = @gateway.latest_cve
        data = data['cves']
        data.map do |cve|
          CVEMapper.build_entity(cve)
        end
      end

      def search(query)
        data = @gateway.search_cve(query)
        data = data['cves']
        data.map do |cve|
          CVEMapper.build_entity(cve)
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
          SMS::Entity::CVE.new(
            id: nil,
            overview: overview,
            tweet_count: tweet_count,
            references: references,
            CVE_ID: cve_id,
            release_date: release_date,
            revise_date: revise_date,
            tweets: tweets
          )
        end

        private

        def overview
          @data['overview']
        end

        def tweet_count
          @data['tweet_count']
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

        def revise_date
          @data['last_revised']
        end

        def tweets
          TweetMapper.load_tweets(@data['tweets']['tweets'])
        end
      end
    end
  end
end
