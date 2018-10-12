require 'http'
require 'yaml'

config = YAML.safe_load(File.read('config/secrets.yml'))

def news_api_path(quary, from, to, source)
  "https://newsapi.org/v2/everything?q=#{quary}&from=#{from}&to=#{to}&sources=#{source}&sortBy=popularity"
end

def call_news_url(config,url)
  HTTP.headers(
          'x-api-key' => config['API_KEY']
  ).get(url)
end

news_response = {}
news_results = {}
start_date = '2018-10-9'
end_date = '2018-10-10'
quary = ''
#HAPPY requests
news_name =['bbc-news','cnn']
news_name.each do |name|
  news_url = news_api_path('top-headlines?sources=', name)
  news_response= call_news_url(config, news_url)
  news = news_response.parse
  news_detail = news['articles']
  news_results = news_detail.to_yaml
  File.write("spec/fixtures/#{name}news_response.yml", news_response.to_yaml)
  File.write("spec/fixtures/#{name}news_results.yml", news_results)
end


