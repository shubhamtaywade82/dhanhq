# frozen_string_literal: true

require_relative "../contracts/margin_calculator_contract"

module Dhanhq
  module API
    # Provides methods for managing funds and margin calculations via Dhanhq's API.
    #
    # The `Funds` class extends `Dhanhq::API::Base` and provides methods to:
    # - Retrieve margin requirements for an order.
    # - Retrieve trading account fund information.
    #
    # Example usage:
    #   # Calculate margin requirements
    #   margin_info = Funds.margin_calculator({
    #     dhanClientId: "123456",
    #     exchangeSegment: "NSE_EQ",
    #     transactionType: "BUY",
    #     quantity: 10,
    #     productType: "CNC",
    #     securityId: "1001",
    #     price: 150.0
    #   })
    #
    #   # Retrieve fund balance
    #   account_balance = Funds.balance
    #
    # @see Dhanhq::API::Base For shared API methods.
    # @see https://dhanhq.co/docs/v2/funds/ Dhanhq API Documentation
    class Funds < Base
      class << self
        # Retrieves margin requirements for an order.
        #
        # @param params [Hash] The request parameters for the margin calculation.
        #   Required keys:
        #   - `dhanClientId` [String] Unique client identifier.
        #   - `exchangeSegment` [String] Segment of the exchange.
        #   - `transactionType` [String] Type of transaction (BUY/SELL).
        #   - `quantity` [Integer] Quantity of the trade.
        #   - `productType` [String] Product type for the order.
        #   - `securityId` [String] Unique identifier for the security.
        #   - `price` [Float] Price of the trade.
        #
        # @return [Hash] The API response as a parsed JSON object.
        # @raise [Dhanhq::Error] If validation fails or the API returns an error.
        #
        # @example Calculate margin requirements:
        #   margin_info = Funds.margin_calculator({
        #     dhanClientId: "123456",
        #     exchangeSegment: "NSE_EQ",
        #     transactionType: "BUY",
        #     quantity: 10,
        #     productType: "CNC",
        #     securityId: "1001",
        #     price: 150.0
        #   })
        def margin_calculator(params)
          validated_params = validate_with(Dhanhq::Contracts::MarginCalculatorContract, params)
          post("/v2/margincalculator", validated_params)
        end

        # Retrieves trading account fund information.
        #
        # @return [Hash] The API response as a parsed JSON object.
        # @raise [Dhanhq::Error] If the API returns an error.
        #
        # @example Retrieve fund balance:
        #   account_balance = Funds.balance
        def balance
          get("/fundlimit")
        end
      end
    end
  end
end
