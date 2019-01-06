# frozen_string_literal: true

folders = %w[security_owasp security_CVEs]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end