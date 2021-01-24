# frozen_string_literal: true

require 'pathname'
require 'bundler/setup'
require 'json'
require 'dotenv/load'

require_relative 'utils'

API_ENV = ENV['RACK_ENV'] ||= 'development' unless defined?(API_ENV)
API_ROOT = Pathname.new(File.expand_path('..', __dir__)) unless defined?(API_ROOT)
API_VERSION = File.read(API_ROOT.join('version')).gsub(/[\n\r]/, '') unless defined?(API_VERSION)

# Require all from Gemfile
Bundler.require(:default, API_ENV)

# Load application
files_to_load = %w[
  lib/crypto.rb
  lib/services/*.rb
  lib/models/*.rb
  lib/api/entities/*.rb
  lib/api/support/*.rb
  lib/api/auth.rb
  lib/api/thresholds.rb
  lib/api/price.rb
  lib/api/core.rb
]

Utils.load_files(files_to_load)

OTR::ActiveRecord.configure_from_file!(API_ROOT.join('config', 'database.yml'))
