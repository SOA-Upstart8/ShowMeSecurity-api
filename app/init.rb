# frozen_string_literal: true

folders = %w[domain controllers infrastructure]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end