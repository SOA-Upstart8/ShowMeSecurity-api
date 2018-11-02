# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'
require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require 'pry'

require_relative '../init.rb'

QUERY = 'Web'
FROM = '2018-10-20'
TO = '2018-10-24'
SOURCE = 'cnn'

NEWS_API_KEY = SMS::App.config.NEWS_API_KEY
SEC_API_KEY = SMS::App.config.SEC_API_KEY

CORRECTNEWS = YAML.safe_load(File.read('spec/fixtures/cnn_results.yml'))
CORRECTCVE = YAML.safe_load(File.read('spec/fixtures/vulner_results.yml'))
