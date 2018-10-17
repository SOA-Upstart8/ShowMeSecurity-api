# frozen_string_literal: true

require_relative 'spec_helper.rb'
describe 'Tests NewsSearch library' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock
    c.filter_sensitive_data('<NEWS_API_KEY>') { API_KEY }
  end

  before do
    VCR.insert_cassette CASSETTE_FILE, record: :new_episodes,
                                       match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end
  describe 'News information' do
    it 'HAPPY: should provide correct news information' do
      articles = NewsSearch::NewsAPI.new(API_KEY).get_news(QUARY, FROM, TO, SOURCE)
      _(articles.size).must_equal CORRECT['size']
      _(articles[0].title).must_equal CORRECT['articles'][0]['title']
      _(articles[0].description).must_equal CORRECT['articles'][0]['description']
      _(articles[0].content).must_equal CORRECT['articles'][0]['content']
      _(articles[1].author).must_equal CORRECT['articles'][1]['author']
      _(articles[0].url).must_equal CORRECT['articles'][0]['url']
      _(articles[0].image).must_equal CORRECT['articles'][0]['urlToImage']
      _(articles[0].time).must_equal CORRECT['articles'][0]['publishedAt']
    end

    it 'SAD: should raise exception when request 30 days ago news' do
      proc do
        NewsSearch::NewsAPI.new(API_KEY).get_news(QUARY, '2018-9-1', TO, SOURCE)
      end.must_raise NewsSearch::NewsAPI::Response::TooOldNews
    end

    it 'SAD: should raise exception when unauthorized' do
      proc do
        NewsSearch::NewsAPI.new('BadAPIKEY').get_news(QUARY, FROM, TO, SOURCE)
      end.must_raise NewsSearch::NewsAPI::Response::Unauthorized
    end
  end
end
