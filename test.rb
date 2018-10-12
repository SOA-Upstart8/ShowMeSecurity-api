require_relative 'lib/news_api'
key = '3798d8d9b44744c3969cf344ce02df14'
news =CodePraise::NewsAPI.new(key)
n = news.get_news('', '2018-10-9', '2018-10-10', 'cnn')
puts n[2].author
