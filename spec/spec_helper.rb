require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require 'vcr'
require 'webmock'

require_relative '../lib/news_api.rb'

QUARY = 'Security'.freeze
FROM = '2018-10-5'.freeze
TO = '2018-10-12'.freeze
SOURCE = 'cnn'.freeze

CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
API_KEY = CONFIG['API_KEY']

CORRECT = YAML.safe_load(File.read('spec/fixtures/cnn_results.yml'))

CASSETTES_FOLDER = 'spec/fixtures/cassettes'.freeze
CASSETTE_FILE = 'news_api'.freeze