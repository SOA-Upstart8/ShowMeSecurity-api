# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require 'vcr'
require 'webmock'

require_relative '../lib/news_api.rb'

QUARY = 'Security'
FROM = '2018-10-5'
TO = '2018-10-12'
SOURCE = 'cnn'

CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
API_KEY = CONFIG['API_KEY']

CORRECT = YAML.safe_load(File.read('spec/fixtures/cnn_results.yml'))

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'news_api'
