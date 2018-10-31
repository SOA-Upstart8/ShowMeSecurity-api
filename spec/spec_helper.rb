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

CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
NEWS_API_KEY = CONFIG['NEWS_API_KEY']
SEC_API_KEY = CONFIG['SEC_API_KEY']

CORRECTNEWS = YAML.safe_load(File.read('spec/fixtures/cnn_results.yml'))
CORRECTCVE = YAML.safe_load(File.read('spec/fixtures/vulner_results.yml'))

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'api_test'
