# frozen_string_literal: true

module Dhanhq
  module Validators
    class OrderValidator < BaseValidator
      REQUIRED_FIELDS = %i[
        dhanClientId transactionType exchangeSegment productType orderType validity securityId quantity
      ].freeze

      VALID_TRANSACTION_TYPES = [Constants::BUY, Constants::SELL].freeze
      VALID_EXCHANGE_SEGMENTS = [
        Constants::NSE, Constants::BSE, Constants::CUR, Constants::FNO, Constants::MCX
      ].freeze
      VALID_PRODUCT_TYPES = [
        Constants::CNC, Constants::INTRA, Constants::MARGIN, Constants::CO, Constants::BO, Constants::MTF
      ].freeze
      VALID_ORDER_TYPES = [Constants::LIMIT, Constants::MARKET, Constants::SL, Constants::SLM].freeze
      VALID_VALIDITY_TYPES = [Constants::DAY, Constants::IOC].freeze
      VALID_AMO_TIMES = %w[OPEN OPEN_30 OPEN_60].freeze
      VALID_OPTION_TYPES = %w[CALL PUT].freeze

      def self.validate(params)
        validate_presence(params, REQUIRED_FIELDS)
        validate_inclusion(params[:transactionType], VALID_TRANSACTION_TYPES, "transactionType")
        validate_inclusion(params[:exchangeSegment], VALID_EXCHANGE_SEGMENTS, "exchangeSegment")
        validate_inclusion(params[:productType], VALID_PRODUCT_TYPES, "productType")
        validate_inclusion(params[:orderType], VALID_ORDER_TYPES, "orderType")
        validate_inclusion(params[:validity], VALID_VALIDITY_TYPES, "validity")
        validate_conditional_params(params)
      end

      def self.validate_conditional_params(params)
        validate_conditional(params, :triggerPrice,
                             condition: lambda { |p|
                               !%w[STOP_LOSS STOP_LOSS_MARKET].include?(p[:orderType]) || p[:triggerPrice]
                             },
                             message: "triggerPrice is required for orderType #{params[:orderType]}")

        validate_conditional(params, :amoTime,
                             condition: ->(p) { !p[:afterMarketOrder] || p[:amoTime] },
                             message: "amoTime is required when afterMarketOrder is true")

        validate_inclusion(params[:amoTime], VALID_AMO_TIMES, "amoTime") if params[:afterMarketOrder]

        validate_presence(params, %i[boProfitValue boStopLossValue]) if params[:productType] == Constants::BO

        return unless params[:exchangeSegment].include?("FNO")

        validate_presence(params, %i[drvExpiryDate drvOptionType drvStrikePrice])
        validate_inclusion(params[:drvOptionType], VALID_OPTION_TYPES, "drvOptionType")
      end
    end
  end
end
