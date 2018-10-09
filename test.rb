require_relative 'lib/news_api'
key = '3798d8d9b44744c3969cf344ce02df14'
news =CodePraise::NewsAPI.new(key).bbc('top-headlines?sources=')
puts news[5].author
