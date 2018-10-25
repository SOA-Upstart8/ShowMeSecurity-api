# frozen_string_literal: true

require 'http'
require 'yaml'

def court_api_path(page, type, year)
  "https://api.jrf.org.tw/search/stories?page=#{page}&q[story_type]=#{type}&q[year]=#{year}"
end

def call_court_url(url)
  HTTP.get(url)
end

page = 1
type = '刑事'
year = 105
# HAPPY requests
court_url = court_api_path(page, type, year)
court_response = call_court_url(court_url)
data = court_response.parse
stories = data['stories']
File.write('spec/fixtures/stories_results.yml', stories.to_yaml)
