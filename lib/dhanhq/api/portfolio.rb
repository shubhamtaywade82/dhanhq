# frozen_string_literal: true

module Dhanhq
  module Api
    # Handles endpoints related to Portfolio, including holdings, positions,
    # and conversion of positions.
    class Portfolio < BaseApi
      class << self
        # Retrieve the list of holdings in the demat account.
        #
        # @return [Array<Hash>] The list of holdings
        #
        # @example Retrieve holdings:
        #   portfolio.holdings
        def holdings
          request(:get, "/holdings")
        end

        # Retrieve the list of open positions.
        #
        # @return [Array<Hash>] The list of open positions
        #
        # @example Retrieve positions:
        #   portfolio.positions
        def positions
          request(:get, "/positions")
        end

        # Convert an open position from one product type to another.
        #
        # @param params [Hash] The request payload for converting the position
        # @return [String] The response status (e.g., '202 Accepted')
        #
        # @example Convert a position:
        #   portfolio.convert_position({
        #     dhanClientId: '1000000009',
        #     fromProductType: 'INTRADAY',
        #     toProductType: 'CNC',
        #     securityId: '11536',
        #     convertQty: 40
        #   })
        def convert_position(params)
          validate_params!(params, Dhanhq::Validators::Portfolio::ConvertPositionSchema)
          request(:post, "/positions/convert", params)
        end
      end
    end
  end
end
