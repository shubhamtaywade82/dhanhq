# frozen_string_literal: true

require "dry-validation"

# Base Setup
require_relative "dhanhq/version"
require_relative "dhanhq/configuration"
# require_relative "dhanhq/client"
require_relative "dhanhq/errors/api_error"
require_relative "dhanhq/errors/client_error"
require_relative "dhanhq/errors/server_error"
require_relative "dhanhq/errors/validation_error"
require_relative "dhanhq/constants"

# Support & Helpers
require_relative "dhanhq/support/faraday_connection"
require_relative "dhanhq/helpers/exchange_helper"

# APIs
require_relative "dhanhq/api/base"
require_relative "dhanhq/api/orders"
require_relative "dhanhq/api/forever_orders"
require_relative "dhanhq/api/funds"
require_relative "dhanhq/api/ledger"
require_relative "dhanhq/api/portfolio"

# Validators
require_relative "dhanhq/validators/base_validator"
require_relative "dhanhq/validators/orders/modify_order_validator"
require_relative "dhanhq/validators/orders/place_order_validator"
require_relative "dhanhq/validators/orders/place_slice_order_validator"
require_relative "dhanhq/validators/funds/margin_calculator_validator"
require_relative "dhanhq/validators/ledger/ledger_report_validator"
require_relative "dhanhq/validators/ledger/trade_history_validator"
require_relative "dhanhq/validators/portfolio/convert_position_validator"
require_relative "dhanhq/validators/data_apis/historical_data_validator"
require_relative "dhanhq/validators/data_apis/marketfeed_ltp_validator"
require_relative "dhanhq/validators/data_apis/marketfeed_ohlc_validator"

# Dhanhq is a Ruby gem for interacting with the DhanHQ Trading API.
#
# @see Dhanhq::API for API interaction methods
module Dhanhq
  class << self
    # @return [Dhanhq::Configuration] The current configuration instance.
    attr_accessor :configuration

    # Configures the gem.
    #
    # @example
    #   Dhanhq.configure do |config|
    #     config.client_id = 'my_client_id'
    #     config.access_token = 'my_access_token'
    #     config.enable_data_api = true
    #   end
    #
    # @yield [Dhanhq::Configuration] Gives the configuration object to the block.
    # Method to configure the gem
    def configure
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
      configuration.validate!
    end
  end
end
