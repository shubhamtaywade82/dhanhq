# frozen_string_literal: true

module Dhanhq
  module Contracts
    class ModifySuperOrderContract < BaseContract
      params do
        optional(:dhanClientId).filled(:string)
        required(:orderId).filled(:string)
        required(:legName).filled(:string, included_in?: %w[ENTRY_LEG TARGET_LEG STOP_LOSS_LEG])
        optional(:orderType).maybe(:string)
        optional(:quantity).maybe(:integer)
        optional(:price).maybe(:float)
        optional(:targetPrice).maybe(:float)
        optional(:stopLossPrice).maybe(:float)
        optional(:trailingJump).maybe(:float)
      end

      rule(:orderType, :legName) do
        # ENTRY_LEG must include quantity & price if modifying entry
        if values[:legName] == "ENTRY_LEG"
          key(:quantity).failure("must be set for ENTRY_LEG") unless values[:quantity]
          key(:price).failure("must be set for ENTRY_LEG") unless values[:price]
        end
      end
    end
  end
end
