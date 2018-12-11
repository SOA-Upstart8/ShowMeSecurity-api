# frozen_string_literal: true

require 'rake/testtask'

desc 'Run unit and integration tests'
Rake::TestTask.new(:spec) do |t|
  t.pattern = 'spec/*_spec.rb'
  t.warning = false
end

desc 'Run acceptance tests'
# NOTE: run `rake run:test` in another process
Rake::TestTask.new(:spec_accept) do |t|
  t.pattern = 'spec/tests_acceptance/*_acceptance.rb'
  t.warning = false
end

desc 'Keep rerunning tests upon changes'
task :respec do
  sh "rerun -c 'rake spec' --ignore 'coverage/*'"
end

task :rerack do
  sh "rerun -c rackup --ignore 'coverage/*'"
end

namespace :cache do
  task :config do
    require_relative 'config/environment.rb' # load config info
    require_relative 'app/infrastructure/cache/init.rb' # load cache client
    @api = SMS::Api
  end

  namespace :list do
    task :dev do
      puts 'Finding development cache'
      list = `ls _cache`
      puts 'No local cache found' if list.empty?
      puts list
    end

    task :production => :config do
      puts 'Finding production cache'
      keys = SMS::Cache::Client.new(@api.config).keys
      puts 'No keys found' if keys.none?
      keys.each { |key| puts "Key: #{key}" }
    end
  end
end
namespace :vcr do
  desc 'delete cassette fixtures'
  task :wipe do
    sh 'rm spec/fixtures/cassettes/*.yml' do |ok, _|
      puts(ok ? 'Cassettes deleted' : 'No cassettes found')
    end
  end
end

namespace :quality do
  task :flog do
    sh 'flog lib/'
  end

  task :reek do
    sh 'reek lib/'
  end

  task :rubocop do
    sh 'rubocop'
  end
end

namespace :quality do
  desc 'run all quality checks'
  task all: [:rubocop, :flog, :reek]
end

namespace :db do
  task :config do
    require 'sequel'
    require_relative 'config/environment.rb' # load config info
    require_relative 'spec/helpers/database_helper.rb'
    @app = SMS::Api
  end

  desc 'Run migrations'
  task :migrate => :config do
    Sequel.extension :migration
    puts "Migration #{@app.environment} database to latest"
    Sequel::Migrator.run(@app.DB, 'app/infrastructure/database/migrations')
  end

  desc 'Wipe records from all tables'
  task :wipe => :config do
    DatabaseHelper.setup_database_cleaner
    DatabaseHelper.wipe_database
  end

  desc 'Delete dev or test database file'
  task :drop => :config do
    if @app.environment == :production
      puts 'Cannot remove production database!'
      return
    end
    FileUtils.rm(SMS::Api.config.DB_FILENAME)
    puts "Deleted #{SMS::Api.config.DB_FILENAME}"
  end
end

desc 'Run application console (pry)'
task :console do
  sh 'pry -r ./init.rb'
end
