# frozen_string_literal: true

require 'faye'
require_relative './init.rb'

use Faye::RackAdapter, mount: '/faye', timeout: 25
run SMS::Api.freeze.app

