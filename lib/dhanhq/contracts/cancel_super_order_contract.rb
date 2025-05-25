# frozen_string_literal: true

module Dhanhq
  module Contracts
    class CancelSuperOrderContract < BaseContract
      params do
        required(:orderId).filled(:string)
        optional(:orderLeg).maybe(:string, included_in?: %w[ENTRY_LEG TARGET_LEG STOP_LOSS_LEG])
      end
    end
  end
end
