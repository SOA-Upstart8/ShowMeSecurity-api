# frozen_string_literal: true

require 'roda'
require 'yaml'

module NewsSentence
  # Configuration for the App
  class App < Roda
    CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
    API_KEY = CONFIG['API_KEY']
  end
end
