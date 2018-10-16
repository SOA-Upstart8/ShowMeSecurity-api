# frozen_string_literal: true

module NewsSearch
  # Model for cnn
  class NEWS
    def initialize(data)
      @data = data
    end

    def author
      @data['author']
    end

    def title
      @data['title']
    end

    def description
      @data['description']
    end

    def url
      @data['url']
    end

    def image
      @data['urlToImage']
    end

    def time
      @data['publishedAt']
    end

    def content
      @data['content']
    end
  end
end
