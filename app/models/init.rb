# frozen_string_literal: true

folders = %w[entities mappers news vulnerabilities]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
