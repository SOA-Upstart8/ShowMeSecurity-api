# frozen_string_literal: true

require_relative 'spec_helper.rb'
describe 'Tests API library' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock
    c.filter_sensitive_data('<NEWS_API_KEY>') { NEWS_API_KEY }
    c.filter_sensitive_data('<SEC_API_KEY>') { SEC_API_KEY }
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
      news = SMS::News::NewsMapper
        .new(NEWS_API_KEY).search(QUERY, FROM, TO, SOURCE)
      _(news[0].source).must_equal CORRECTNEWS['articles'][0]['source']['name']
      _(news[0].title).must_equal CORRECTNEWS['articles'][0]['title']
      _(news[0].content).must_equal CORRECTNEWS['articles'][0]['content']
    end

    it 'SAD: should raise exception when request 30 days ago news' do
      proc do
        SMS::News::NewsMapper
          .new(NEWS_API_KEY).search(QUERY, '2018-9-1', TO, SOURCE)
      end.must_raise SMS::News::Api::Response::TooOldNews
    end

    it 'SAD: should raise exception when News API unauthorized' do
      proc do
        SMS::News::NewsMapper
          .new('Bad Api Key').search(QUERY, FROM, TO, SOURCE)
      end.must_raise SMS::News::Api::Response::Unauthorized
    end
  end

  describe 'SEC information' do
    it 'HAPPY: should provide correct CVE information' do
      CVEs = SMS::CVE::CVEMapper
        .new(SEC_API_KEY).search
      CVEs.each_with_index do |cve, id|
        _(cve.overview).must_equal CORRECTCVE[id]['overview']
        _(cve.CVE_ID).must_equal CORRECTCVE[id]['CVE_ID']
        _(cve.tweet_count).must_equal CORRECTCVE[id]['tweet_count']
        tweets = CORRECTCVE[id]['tweets']['tweets']
        tweets.each_with_index do |tweet, index|
          _(cve.tweets[index].content).must_equal tweet['text']
          _(cve.tweets[index].favorite_count).must_equal tweet['favorite_count']
          _(cve.tweets[index].reply_count).must_equal tweet['reply_count']
          _(cve.tweets[index].owner.user_id).must_equal tweet['user']['id']
          _(cve.tweets[index].owner.name).must_equal tweet['user']['name']
        end
      end
    end

    it 'SAD: should raise exception when SEC API unauthorized' do
      proc do
        SMS::CVE::CVEMapper
          .new('').latest
      end.must_raise SMS::CVE::Api::Response::InvalidCredential
    end
  end
end
