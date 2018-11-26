# frozen_string_literal: true

require_relative 'helpers/spec_helper.rb'
require_relative 'helpers/vcr_helper.rb'

describe 'Tests API library' do
  before do
    VcrHelper.configure_vcr_for_api
  end

  after do
    VcrHelper.eject_vcr
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
      cves = SMS::CVE::CVEMapper
        .new(SEC_API_KEY).search('web')
      cves.each_with_index do |cve, id|
        _(cve.overview).must_equal CORRECTCVE[id]['overview']
        _(cve.CVE_ID).must_equal CORRECTCVE[id]['CVE_ID']
        _(cve.tweet_count).must_equal CORRECTCVE[id]['tweet_count']
        tweets = CORRECTCVE[id]['tweets']['tweets']
        tweets.each_with_index do |tweet, index|
          _(cve.tweets[index].content).must_equal tweet['text']
          _(cve.tweets[index].favorite_count).must_equal tweet['favorite_count']
          _(cve.tweets[index].reply_count).must_equal tweet['reply_count']
          _(cve.tweets[index].owner_id).must_equal tweet['user']['id']
          _(cve.tweets[index].owner_name).must_equal tweet['user']['name']
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
