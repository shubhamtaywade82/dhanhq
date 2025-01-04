# frozen_string_literal: true

require_relative "../contracts/convert_position_contract"
module Dhanhq
  module API
    # Provides methods to manage portfolio data via Dhanhq's API.
    #
    # The `Portfolio` class extends `Dhanhq::API::Base` and includes methods to:
    # - Retrieve holdings and positions.
    # - Convert positions between intraday and delivery modes.
    #
    # Example usage:
    #   # Retrieve all holdings
    #   holdings = Portfolio.holdings
    #
    #   # Retrieve all open positions
    #   positions = Portfolio.positions
    #
    #   # Convert a position
    #   conversion = Portfolio.convert({
    #     dhanClientId: "123456",
    #     fromProductType: "INTRADAY",
    #     toProductType: "CNC",
    #     positionType: "LONG",
    #     securityId: "1001",
    #     convertQty: 10,
    #     exchangeSegment: "NSE_EQ"
    #   })
    #
    # @see Dhanhq::API::Base For shared API methods.
    # @see Dhanhq::Contracts::ConvertPositionContract For Convert Position validation.
    # @see https://dhanhq.co/docs/v2/portfolio/ Dhanhq API Documentation
    class Portfolio < Base
      class << self
        # Retrieves all holdings for the client.
        #
        # @return [Array<Hash>] The list of holdings as parsed JSON objects.
        # @raise [Dhanhq::Error] If the API returns an error.
        #
        # @example Retrieve all holdings:
        #   holdings = Portfolio.holdings
        def holdings
          get("/holdings")
        end

        # Retrieves all open positions for the client.
        #
        # @return [Array<Hash>] The list of open positions as parsed JSON objects.
        # @raise [Dhanhq::Error] If the API returns an error.
        #
        # @example Retrieve all open positions:
        #   positions = Portfolio.positions
        def positions
          get("/positions")
        end

        # Converts a position between intraday and delivery (or vice versa).
        #
        # @param params [Hash] The request parameters for position conversion.
        #   Required keys:
        #   - `dhanClientId` [String] Unique client identifier.
        #   - `fromProductType` [String] The current product type of the position (e.g., "INTRADAY").
        #   - `toProductType` [String] The target product type after conversion (e.g., "CNC").
        #   - `positionType` [String] The type of position (e.g., "LONG", "SHORT").
        #   - `securityId` [String] Unique identifier for the security.
        #   - `convertQty` [Integer] The quantity to convert.
        #   - `exchangeSegment` [String] The exchange segment of the position (e.g., "NSE_EQ").
        #
        # @return [Hash] The API response as a parsed JSON object.
        # @raise [Dhanhq::Error] If validation fails or the API returns an error.
        #
        # @example Convert a position:
        #   conversion = Portfolio.convert({
        #     dhanClientId: "123456",
        #     fromProductType: "INTRADAY",
        #     toProductType: "CNC",
        #     positionType: "LONG",
        #     securityId: "1001",
        #     convertQty: 10,
        #     exchangeSegment: "NSE_EQ"
        #   })
        def convert(params)
          validated_params = validate_with(Dhanhq::Contracts::ConvertPositionContract, params)
          post("/positions/convert", validated_params)
        end
      end
    end
  end
end
