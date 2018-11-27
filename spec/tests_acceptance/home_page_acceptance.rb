# frozen_string_literal: true

require_relative '../helpers/acceptance_helper.rb'
require_relative 'pages/home_page.rb'

describe 'Home Acceptance Tests' do
  include PageObject::PageFactory

  DatabaseHelper.setup_database_cleaner

  before do
    DatabaseHelper.wipe_database
    @headless = Headless.new
    @browser = Watir::Browser.new
  end

  after do
    @browser.close
    @headless.destroy
  end

  describe 'Visit Home Page' do
    it '(HAPPY) should see latest cves' do
      # GIVEN: user is on the home page without any queries
      visit HomePage do |page|
        # THEN: user should see basic headers, latest cve_id and overview
        _(page.title_heading).must_equal 'Show Me Security'
        _(page.query_input.present?).must_equal true
        _(page.query_button.present?).must_equal true
        _(page.first_latest_cve.present?).must_equal true
      end
    end
  end
  describe 'Search CVE' do
    it '(HAPPY) should be able to request a query' do
      # GIVEN: user is on the home page without any queries
      # WHEN: they input query and submit
      visit HomePage do |page|
        good_query = 'XSS'
        page.search_cve(good_query)

        # THEN: they should find query result on the cve page
        @browser.url.include? cve
        @browser.url.include? good_query
      end
    end
    it '(BAD) should not be able to add an invalid query' do
      # GIVEN: user is on the home page without any queries
      visit HomePage do |page|
        bad_query = '/////'
        page.search_cve(bad_query)
        # THEN: they should see a warning message
        _(page.warning_message.downcase).must_include 'invalid'
      end
    end
  end
end
