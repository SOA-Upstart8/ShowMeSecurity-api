# frozen_string_literal: true

require_relative '../helpers/acceptance_helper.rb'
require_relative 'pages/home_page.rb'

describe 'Acceptance Tests' do
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

  describe 'Homepage' do
    describe 'Visit Home Page' do
      it '(HAPPY) should see latest cves' do
        # GIVEN: user is on the home page without any queries
        @browser.goto homepage

        # THEN: user should see basic headers, latest cve_id and overview
        _(@browser.h1(id: 'main_header').text).must_equal 'Show Me Security'
        _(@browser.text_field(id: 'query_input').present?).must_equal true
        _(@browser.button(id: 'query_submit').present?).must_equal true
        _(@browser.div(class: 'card-title').present?).must_equal true
        _(@browser.div(class: 'card-text').present?).must_equal true
      end
    end

    describe 'Search CVE' do
      it '(HAPPY) should be able to request a query' do
        # GIVEN: user is on the home page without any queries
        @browser.goto homepage

        # WHEN: they add a project URL and submit
        good_query = 'XSS'
        @browser.text_field(id: 'query_input').set(good_query)
        @browser.button(id: 'query_submit').click

        # THEN: they should find query result on the cve page
        @browser.url.include? cve
        @browser.url.include? good_query
      end

      it '(BAD) should not be able to add an invalid query' do
        # GIVEN: user is on the home page without any queries
        @browser.goto homepage

        # WHEN: their query is an invalid string
        bad_query = '///////'
        @browser.text_field(id: 'query_input').set(bad_query)
        @browser.button(id: 'query_submit').click

        # THEN: they should see a warning message
        _(@browser.div(id: 'flash_bar_danger').present?).must_equal true
        _(@browser.div(id: 'flash_bar_danger').text.downcase).must_include 'invalid'
      end
    end

  end
end
