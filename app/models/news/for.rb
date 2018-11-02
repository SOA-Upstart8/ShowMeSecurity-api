# frozen_string_literal: true

module SMS
  module News
    class For
      ENTITY_NEWS = {
        Entity::News => News
      }.freeze

      def self.klass(entity_klass)
        ENTITY_NEWS[entity_klass]
      end

      def self.entity(entity_object)
        ENTITY_NEWS[entity_object.class]
      end
    end
  end
end
