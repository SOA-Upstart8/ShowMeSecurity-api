# frozen_string_literal: true

require 'roda'
require 'slim'

module NewsSentence
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :halt

    route do |routing|
        routing.assets

        # GET /
        routing.root do
            view 'home'
        end

        routing.on 'news' do
            routing.is do
                # POST /news/
                routing.post do
                    query = routing.params['query']
                    from = routing.params['from']
                    to = routing.params['to']
                    source = routing.params['source']

                    routing.redirect "news/#{query}/#{from}/#{to}/#{source}"
                end
            end

            routing.on String, String, String, String do |query, from, to, source|
                # GET /news/query/from/to/source
                routing.get do
                    news = NewsSentence::News::NewsMapper.new(API_KEY).search(query, from, to, source)
                    
                    view 'news', locals: { news_detail: news }
                end
            end
        end
    end

  end
end