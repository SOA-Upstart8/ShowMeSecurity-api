# frozen_string_literal: true

folders = %w[security_categories security_CVEs]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end