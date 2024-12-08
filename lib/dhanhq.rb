# frozen_string_literal: true

require "dry-validation"

# Base Setup
require_relative "dhanhq/version"
require_relative "dhanhq/configuration"
require_relative "dhanhq/client"
require_relative "dhanhq/errors"

# Helpers
require_relative "dhanhq/helpers/constants"
require_relative "dhanhq/helpers/exchange_helper"

# Dynamically load all files under `lib/dhanhq`
Dir[File.join(__dir__, "dhanhq/**/*.rb")].each { |file| require file }

# Dhanhq is a Ruby gem for interacting with the DhanHQ Trading API.
#
# @see Dhanhq::API for API interaction methods
module Dhanhq
  class << self
    # @return [Dhanhq::Configuration] The configuration instance.
    attr_accessor :configuration

    # Configures the gem.
    #
    # @example
    #   Dhanhq.configure do |config|
    #     config.base_url = 'https://api.example.com'
    #     config.client_id = 'my_client_id'
    #     config.access_token = 'my_access_token'
    #   end
    #
    # @yield [Dhanhq::Configuration] Gives the configuration object to the block.
    def configure
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
    end
  end
end
