# frozen_string_literal: true

module Dhanhq
  module Contracts
    # Validation contract for converting a position via Dhanhq's API.
    #
    # This contract validates the parameters required to convert a position from one product type
    # to another. It ensures consistency in input values, including exchange segment, product types,
    # and position type.
    #
    # Example usage:
    #   contract = Dhanhq::Contracts::ConvertPositionContract.new
    #   result = contract.call(
    #     dhanClientId: "123456",
    #     fromProductType: "INTRADAY",
    #     exchangeSegment: "NSE_EQ",
    #     positionType: "LONG",
    #     securityId: "1001",
    #     tradingSymbol: "RELIANCE",
    #     convertQty: 10,
    #     toProductType: "CNC"
    #   )
    #   result.success? # => true or false
    #
    # @see https://dhanhq.co/docs/v2/ Dhanhq API Documentation
    class ConvertPositionContract < BaseContract
      # Parameters and validation rules for the Convert Position request.
      #
      # @!attribute [r] dhanClientId
      #   @return [String] Required. Unique client identifier from Dhanhq.
      # @!attribute [r] fromProductType
      #   @return [String] Required. The current product type of the position.
      #     Must be one of: `PRODUCT_TYPES`.
      # @!attribute [r] exchangeSegment
      #   @return [String] Required. The exchange segment of the position.
      #     Must be one of: `EXCHANGE_SEGMENTS`.
      # @!attribute [r] positionType
      #   @return [String] Required. The type of position.
      #     Must be one of: LONG, SHORT, CLOSED.
      # @!attribute [r] securityId
      #   @return [String] Required. Unique identifier for the security.
      # @!attribute [r] tradingSymbol
      #   @return [String] Optional. The trading symbol of the instrument.
      # @!attribute [r] convertQty
      #   @return [Integer] Required. The quantity of the position to convert, must be greater than 0.
      # @!attribute [r] toProductType
      #   @return [String] Required. The target product type after conversion.
      #     Must be one of: `PRODUCT_TYPES`.
      #
      #   @example Valid input:
      #     {
      #       fromProductType: "INTRADAY",
      #       exchangeSegment: "NSE_EQ",
      #       positionType: "LONG",
      #       securityId: "1001",
      #       convertQty: 10,
      #       toProductType: "CNC"
      #     }
      #   @example Invalid conversion:
      #     {
      #       fromProductType: "CNC",
      #       toProductType: "CNC"
      #     }
      #     => Adds failure message "fromProductType cannot be the same as toProductType".
      params do
        required(:fromProductType).filled(:string, included_in?: PRODUCT_TYPES)
        required(:exchangeSegment).filled(:string, included_in?: EXCHANGE_SEGMENTS)
        required(:positionType).filled(:string, included_in?: %w[LONG SHORT CLOSED])
        required(:securityId).filled(:string)
        optional(:tradingSymbol).maybe(:string)
        required(:convertQty).filled(:integer, gt?: 0)
        required(:toProductType).filled(:string, included_in?: PRODUCT_TYPES)
      end

      # Custom rule to ensure `fromProductType` and `toProductType` are not the same.
      #
      # @example Invalid conversion:
      #   fromProductType: "CNC", toProductType: "CNC"
      #   => Adds failure message "fromProductType cannot be the same as toProductType".
      #
      # @param fromProductType [String] The current product type of the position.
      # @param toProductType [String] The target product type of the position.
      rule(:fromProductType, :toProductType) do
        if values[:fromProductType] == values[:toProductType]
          key(:fromProductType).failure("cannot be the same as toProductType")
        end
      end
    end
  end
end
