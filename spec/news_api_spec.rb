require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/news_api.rb'

describe 'Tests NewsSearch library' do
    QUARY = 'Security'.freeze
    FROM = '2018-10-5'.freeze
    TO = '2018-10-12'.freeze
    SOURCE = 'cnn'.freeze

    CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
    API_KEY = CONFIG['API_KEY']

    CORRECT = YAML.safe_load(File.read('spec/fixtures/cnn_results.yml'))

    describe 'News information' do
        it 'HAPPY: should provide correct news information' do
            articles = NewsSearch::NewsAPI.new(API_KEY).get_news(QUARY, FROM, TO, SOURCE)
            _(articles.size).must_equal CORRECT['size']
            _(articles[0].title).must_equal CORRECT['articles'][0]['title']
            _(articles[1].description).must_equal CORRECT['articles'][1]['description']
            _(articles[2].content).must_equal CORRECT['articles'][2]['content']
            _(articles[3].author).must_equal CORRECT['articles'][3]['author']
        end
        
        it 'SAD: should raise exception when request 30 days ago news' do
            proc do
               NewsSearch::NewsAPI.new(API_KEY).get_news(QUARY, '2018-9-1', TO, SOURCE)
            end.must_raise NewsSearch::NewsAPI::Errors::TooManyRequests
       end

        it 'SAD: should raise exception when unauthorized' do
            proc do
                NewsSearch::NewsAPI.new('BadAPIKEY').get_news(QUARY, FROM, TO, SOURCE)
            end.must_raise NewsSearch::NewsAPI::Errors::Unauthorized
        end
    end
end
    


    

