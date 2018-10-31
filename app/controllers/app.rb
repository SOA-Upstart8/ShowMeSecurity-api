# frozen_string_literal: true

require 'roda'
require 'slim'

module NewsSentence
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :halt

    # load css
    route do |routing|
        routing.assets

        # GET /
        routing.root do
            home_news = News::NewsMapper.new('3798d8d9b44744c3969cf344ce02df14').search_headlines('tw')

            view 'home', locals: { home: home_news }
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
                    news_detail = News::NewsMapper.new('3798d8d9b44744c3969cf344ce02df14').search(query, from, to, source)
                    
                    view 'news', locals: { news: news_detail }
                end
            end
        end
    end

  end
end