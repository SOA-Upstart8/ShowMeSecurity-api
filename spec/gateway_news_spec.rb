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
      news = NewsSentence::News::NewsMapper
        .new(API_KEY).search(QUERY, FROM, TO, SOURCE)
      _(news[0].source).must_equal CORRECT['articles'][0]['source']['name']
      _(news[0].title).must_equal CORRECT['articles'][0]['title']
      _(news[0].content).must_equal CORRECT['articles'][0]['content']
    end

    it 'SAD: should raise exception when request 30 days ago news' do
      proc do
        NewsSentence::News::NewsMapper
          .new(API_KEY).search(QUERY, '2018-9-1', TO, SOURCE)
      end.must_raise NewsSentence::News::Api::Response::TooOldNews
    end

    it 'SAD: should raise exception when unauthorized' do
      proc do
        NewsSentence::News::NewsMapper
          .new("Bad Api Key").search(QUERY, FROM, TO, SOURCE)
      end.must_raise NewsSentence::News::Api::Response::Unauthorized
    end
  end
end
