# frozen_string_literal: true

module SMS
  module CVE
    # Data Mapper: NewsApi data -> News entity
    class ExpertMapper
      def self.build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Ettract entity specific element from data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          SMS::Entity::Expert.new(
            id: nil,
            user_id: user_id,
            image: image,
            follower_count: follower_count,
            name: name,
            user_page: user_page
          )
        end

        private

        def user_id
          @data['id']
        end

        def image
          @data['profile_image_url_https']
        end

        def follower_count
          @data['followers_count']
        end

        def name
          @data['name']
        end

        def user_page
          'https://twitter.com/intent/user?user_id=' + @data['id_str']
        end
      end
    end
  end
end
