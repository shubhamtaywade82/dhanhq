# frozen_string_literal: true

module Dhanhq
  module Api
    # Handles endpoints related to Funds, including Margin Calculator and Fund Limit.
    class Funds < Base
      class << self
        # Retrieve trading account fund information, including available balance, utilized funds, etc.
        #
        # @return [Hash] Fund details, including available balance and margins
        #
        # @example Retrieve fund limit:
        #   funds.fund_limit
        def fund_limit
          request(:get, "/fundlimit")
        end

        # Calculate margin requirements for an order.
        #
        # @param params [Hash] The request payload for the margin calculation
        # @return [Hash] Margin details, including required margin and available balance
        #
        # @example Calculate margin:
        #   funds.calculate_margin({
        #     dhanClientId: '1000000132',
        #     exchangeSegment: 'NSE_EQ',
        #     transactionType: 'BUY',
        #     quantity: 5,
        #     productType: 'CNC',
        #     securityId: '1333',
        #     price: 1428
        #   })
        def calculate_margin(params)
          validate_params!(params, Dhanhq::Validators::Funds::CalculateMarginValidator)
          request(:post, "/margincalculator", params)
        end
      end
    end
  end
end
