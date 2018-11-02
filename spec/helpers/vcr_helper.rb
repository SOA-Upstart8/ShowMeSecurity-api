# frozen_string_literal: true

require 'vcr'
require 'webmock'

# Setting up VCR
class VcrHelper
  CASSETTES_FOLDER = 'spec/fixtures/cassettes'
  GITUB_CASSETTE = 'api'

  def self.setup_vcr
    VCR.configure do |c|
      c.cassette_library_dir = CASSETTES_FOLDER
      c.hook_into :webmock
    end
  end

  def self.configure_vcr_for_api
    VCR.configure do |c|
      c.filter_sensitive_data('<NEWS_API_KEY>') { NEWS_API_KEY }
      c.filter_sensitive_data('<SEC_API_KEY>') { SEC_API_KEY }
    end

    VCR.insert_cassette(
      GITUB_CASSETTE,
      record: :new_episodes,
      match_requests_on: %i[method uri headers]
    )
  end

  def self.eject_vcr
    VCR.eject_cassette
  end
end
