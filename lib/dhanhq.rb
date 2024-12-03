# frozen_string_literal: true

require_relative "dhanhq/version"
require_relative "dhanhq/configuration"

# Require the client
require_relative "dhanhq/client"
require_relative "dhanhq/errors"

# Require helpers
require_relative "dhanhq/helpers/constants"
require_relative "dhanhq/helpers/validator"
require_relative "dhanhq/websockets/constants"

# Require the apis
require_relative "dhanhq/base_api"
require_relative "dhanhq/api/orders"
require_relative "dhanhq/api/portfolio"
require_relative "dhanhq/api/funds"
require_relative "dhanhq/api/forever_orders"
require_relative "dhanhq/api/ledger"
require_relative "dhanhq/api/positions"

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
