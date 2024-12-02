# frozen_string_literal: true

module Dhanhq
  module Validators
    class OrderModificationValidator < BaseValidator
      REQUIRED_FIELDS = %i[
        dhanClientId orderId orderType quantity price validity
      ].freeze

      VALID_ORDER_TYPES = %w[LIMIT MARKET STOP_LOSS STOP_LOSS_MARKET].freeze
      VALID_LEG_NAMES = %w[ENTRY_LEG TARGET_LEG STOP_LOSS_LEG].freeze
      VALID_VALIDITY_TYPES = %w[DAY IOC].freeze

      def self.validate(params)
        validate_presence(params, REQUIRED_FIELDS)
        validate_inclusion(params[:orderType], VALID_ORDER_TYPES, "orderType")
        validate_inclusion(params[:validity], VALID_VALIDITY_TYPES, "validity")
        validate_conditional_params(params)
      end

      def self.validate_conditional_params(params)
        # Conditional validation for `triggerPrice`
        validate_conditional(params, :triggerPrice,
                             condition: lambda { |p|
                               !%w[STOP_LOSS STOP_LOSS_MARKET].include?(p[:orderType]) || p[:triggerPrice]
                             },
                             message: "triggerPrice is required for orderType #{params[:orderType]}")

        # Conditional validation for `legName`
        validate_conditional(params, :legName,
                             condition: ->(p) { !%w[CO BO].include?(p[:orderType]) || p[:legName] },
                             message: "legName is required for orderType #{params[:orderType]} when using CO/BO")
        validate_inclusion(params[:legName], VALID_LEG_NAMES, "legName") if params[:legName]
      end
    end
  end
end
