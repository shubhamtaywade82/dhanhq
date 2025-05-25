# frozen_string_literal: true

module Dhanhq
  module Contracts
    class PlaceSuperOrderContract < BaseContract
      params do
        optional(:dhanClientId).filled(:string)
        optional(:correlationId).maybe(:string)
        required(:transactionType).filled(:string, included_in?: %w[BUY SELL])
        required(:exchangeSegment).filled(:string)
        required(:productType).filled(:string)
        required(:orderType).filled(:string)
        required(:securityId).filled(:string)
        required(:quantity).filled(:integer, gt?: 0)
        required(:price).filled(:float, gt?: 0.0)
        required(:targetPrice).filled(:float)
        required(:stopLossPrice).filled(:float)
        required(:trailingJump).filled(:float)
      end
    end
  end
end
