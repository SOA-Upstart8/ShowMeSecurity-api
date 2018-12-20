# frozen_string_literal: true

module SMS
  module CVE
    # Data Mapper: NewsApi data -> News entity
    class OwaspRefMapper
      def self.load_references(data)
        data.map { |ref| OwaspRefMapper.build_entity(ref) }
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
          SMS::Entity::OwaspRef.new(
            id: nil,
            link: link
          )
        end

        private

        def link
          @data['Hyperlink']
        end
      end
    end
  end
end
