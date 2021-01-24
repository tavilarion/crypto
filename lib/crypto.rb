# frozen_string_literal: true

module Crypto
  def self.config
    @config ||= YAML.load(ERB.new(File.read(API_ROOT.join('config', 'application.yml'))).result)[API_ENV]
                    .deep_symbolize_keys.freeze
  end

  def self.logger
    @logger ||= Logger.new($stdout)
  end
end
