# frozen_string_literal: true

module Dhanhq
  module Contracts
    #
    # Validates the payload for POST /v2/super/orders
    #
    # • Re-uses the same enum constants as PlaceOrderContract
    # • price is mandatory only for LIMIT entry legs
    # • trailingJump may be 0 (→ no trail) but never negative
    #
    class PlaceSuperOrderContract < BaseContract
      params do
        # ────────────────────────────────────────── identifiers
        optional(:dhanClientId).maybe(:string) # auto-filled by token in most cases
        optional(:correlationId).maybe(:string, max_size?: 25)

        # ────────────────────────────────────────── core fields
        required(:transactionType).filled(:string, included_in?: TRANSACTION_TYPES) # BUY / SELL
        required(:exchangeSegment).filled(:string, included_in?: EXCHANGE_SEGMENTS)
        required(:productType).filled(:string, included_in?: PRODUCT_TYPES)         # CNC / INTRADAY / MARGIN / MTF
        required(:orderType).filled(:string, included_in?: ORDER_TYPES)             # LIMIT / MARKET
        required(:securityId).filled(:string)
        required(:quantity).filled(:integer, gt?: 0)

        # ────────────────────────────────────────── prices
        optional(:price).maybe(:float, gt?: 0) # Mand. for LIMIT, forbidden for MARKET
        required(:targetPrice).filled(:float, gt?: 0)
        required(:stopLossPrice).filled(:float, gt?: 0)
        required(:trailingJump).filled(:float, gteq?: 0)

        # Future-proof – allow DAY validity if API adds it
        optional(:validity).maybe(:string, included_in?: %w[DAY])
      end

      # ──────────────────────────────────────────────────────────
      # Custom rules
      # ──────────────────────────────────────────────────────────
      rule(:price, :orderType) do
        if values[:orderType] == "LIMIT" && values[:price].nil?
          key(:price).failure("is required for LIMIT orderType")
        elsif values[:orderType] == "MARKET" && values[:price]
          key(:price).failure("must be omitted for MARKET orderType")
        end
      end

      rule(:trailingJump) do
        key.failure("must be >= 0") if value && value.negative?
      end
    end
  end
end
