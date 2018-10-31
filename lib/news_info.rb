# frozen_string_literal: true

require 'http'
require 'yaml'

config = YAML.safe_load(File.read('config/secrets.yml'))

def news_api_path(quary, from, to, source)
  "https://newsapi.org/v2/everything?q=#{quary}&from=#{from}&to=#{to}&sources=#{source}"
end

def call_news_url(config, url)
  HTTP.headers(
    'x-api-key' => config['NEWS_API_KEY']
  ).get(url)
end

news_response = {}
news_results = {}
start_date = '2018-10-01'
end_date = '2018-10-15'
quary = 'taiwan'
# HAPPY requests
sources = ['bbc']
sources.each do |source|
  news_url = news_api_path(quary, start_date, end_date, source)
  news_response = call_news_url(config, news_url)
  news = news_response.parse
  news_detail = news['articles']
  news_results['source'] = source
  news_results['size'] = news_detail.count
  news_results['articles'] = news_detail
  #File.write("spec/fixtures/#{source}_response.yml", news_response.to_yaml)
  File.write("spec/fixtures/#{source}_results.yml", news_results.to_yaml)
end
