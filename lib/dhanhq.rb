# frozen_string_literal: true

require "dry-validation"

require_relative "dhanhq/version"
require_relative "dhanhq/configuration"
require_relative "dhanhq/client"
require_relative "dhanhq/errors"

# Helpers
require_relative "dhanhq/helpers/constants"
require_relative "dhanhq/helpers/exchange_helper"

# Validators
require_relative "dhanhq/validators/orders/place_order_validator"
require_relative "dhanhq/validators/orders/modify_order_validator"
require_relative "dhanhq/validators/orders/cancel_order_validator"
require_relative "dhanhq/validators/ledger/ledger_report_validator"
require_relative "dhanhq/validators/ledger/trade_history_validator"
require_relative "dhanhq/validators/funds/calculate_margin_validator"
require_relative "dhanhq/validators/forever_orders/create_forever_order_validator"
require_relative "dhanhq/validators/forever_orders/modify_forever_order_validator"

# APIs
require_relative "dhanhq/api/base_api"
require_relative "dhanhq/api/orders"
require_relative "dhanhq/api/ledger"
require_relative "dhanhq/api/funds"
require_relative "dhanhq/api/forever_orders"
require_relative "dhanhq/api/portfolio"

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
