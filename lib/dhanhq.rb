# frozen_string_literal: true

require_relative "dhanhq/version"
require "dhanhq/constants"
require "dhanhq/client"
require "dhanhq/configuration"
require "dhanhq/error"

require "dhanhq/api/base"
require "dhanhq/api/statements"

# Trading APIs
require "dhanhq/api/orders"
require "dhanhq/api/funds"
require "dhanhq/api/portfolio"
require "dhanhq/api/market_feed"
require "dhanhq/api/historical"
require "dhanhq/api/option"
require "dhanhq/api/super_orders"

require "dhanhq/contracts/base_contract"
require "dhanhq/parsers/binary_parser"

# Websockets
require "dhanhq/websockets/live_market_feed"

# Dhanhq is a Ruby gem for interacting with the Dhanhq Trading API.
#
# @see Dhanhq::API for API interaction methods
module Dhanhq
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end
  end
end
