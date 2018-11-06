# frozen_string_literal: false

require_relative 'spec_helper.rb'
require_relative 'helpers/vcr_helper.rb'
require_relative 'helpers/database_helper.rb'

describe 'Integration Tests of News and Sec API and Database' do
  VcrHelper.setup_vcr
  DatabaseHelper.setup_database_cleaner

  before do
    VcrHelper.configure_vcr_for_api
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store news' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to save remote news data to database' do
      newss = SMS::News::NewsMapper
        .new(NEWS_API_KEY).search(QUERY, FROM, TO, SOURCE)

      newss.each do |news|
        SMS::Repository::For.entity(news).create(news)
      end

      rebuilt = SMS::Repository::News.all

      rebuilt.each_with_index do |news, id|
        _(news.source).must_equal(newss[id].source)
        _(news.title).must_equal(newss[id].title)
        _(news.content).must_equal(newss[id].content)
      end
    end
  end
  describe 'Retrieve and store vulnerability' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to save remote cve data to database' do
      cves = SMS::CVE::CVEMapper
        .new(SEC_API_KEY).search('Web')
      cves.each do |cve|
        SMS::Repository::For.entity(cve).create(cve)
      end
      rebuilt = SMS::Repository::CVEs.all
      rebuilt.each_with_index do |cve, id|
        _(cve.overview).must_equal(cves[id].overview)
        _(cve.CVE_ID).must_equal(cves[id].CVE_ID)
        _(cve.tweet_count).must_equal(cves[id].tweet_count)

        cves[id].references.each do |ref|
          found = SMS::Repository::References.find(ref)
          _(found.link).must_equal(ref.link)
        end

        cves[id].tweets.each do |tweet|
          found = SMS::Repository::Tweets.find(tweet)
          _(found.content).must_equal(tweet.content)
          _(found.favorite_count).must_equal(tweet.favorite_count)
          _(found.reply_count).must_equal(tweet.reply_count)
          _(found.owner_id).must_equal(tweet.owner_id)
          _(found.owner_name).must_equal(tweet.owner_name)
          _(found.owner_page).must_equal(tweet.owner_page)
        end
      end
    end
  end
end
