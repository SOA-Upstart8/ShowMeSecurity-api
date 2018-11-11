# frozen_string_literal: true

folders = %w[values entities mappers]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end