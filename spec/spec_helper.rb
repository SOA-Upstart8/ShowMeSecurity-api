# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require 'vcr'
require 'webmock'

require_relative '../init.rb'

QUERY = 'Web'
FROM = '2018-10-20'
TO = '2018-10-24'
SOURCE = 'cnn'

PAGE = 1
TYPE = '刑事'
YEAR = 105

CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
API_KEY = CONFIG['API_KEY']

CORRECTNEWS = YAML.safe_load(File.read('spec/fixtures/cnn_results.yml'))
CORRECTSTORY = YAML.safe_load(File.read('spec/fixtures/stories_results.yml'))

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'news_api'
