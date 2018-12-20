# frozen_string_literal: true

require 'database_cleaner'

# Helper to clean database during test runs
class DatabaseHelper
  def self.setup_database_cleaner
    DatabaseCleaner.allow_remote_database_url = true
    DatabaseCleaner.strategy = :deletion
    DatabaseCleaner.allow_production = true
    DatabaseCleaner.allow_remote_database_url = true
    DatabaseCleaner.start
  end

  def self.wipe_database
    SMS::Api.DB.run('PRAGMA foreign_keys = OFF')
    DatabaseCleaner.clean
    SMS::Api.DB.run('PRAGMA foreign_keys = ON')
  end
end
