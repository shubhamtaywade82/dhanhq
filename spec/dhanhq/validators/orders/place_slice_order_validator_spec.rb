# frozen_string_literal: true

require "spec_helper"
require_relative "../../../../lib/dhanhq/validators/orders/place_slice_order_validator"
require_relative "../../../../lib/dhanhq/constants"

RSpec.describe Dhanhq::Validators::Orders::PlaceSliceOrderValidator do
  subject(:place_slice_order_validator) { described_class.new }

  let(:valid_params) do
    {
      transactionType: "BUY",
      exchangeSegment: "NSE_EQ",
      productType: "INTRADAY",
      orderType: "MARKET",
      securityId: "11536",
      quantity: 5,
      validity: "DAY",
      dhanClientId: "client_123",
      correlationId: "123abc678"
    }
  end

  context "when all required fields are valid" do
    it "validates successfully" do
      result = place_slice_order_validator.call(valid_params)
      expect(result.success?).to be(true)
    end
  end

  context "when transactionType is invalid" do
    it "returns an error for transactionType" do
      params = valid_params.merge(transactionType: "INVALID")
      result = place_slice_order_validator.call(params)
      expect(result.errors[:transactionType]).to include("must be one of: #{Dhanhq::Constants::TRANSACTION_TYPES.join(", ")}")
    end
  end

  context "when orderType is STOP_LOSS but triggerPrice is missing" do
    it "returns an error for triggerPrice" do
      params = valid_params.merge(orderType: "STOP_LOSS", triggerPrice: nil)
      result = place_slice_order_validator.call(params)
      expect(result.errors[:triggerPrice]).to include("is required and must be greater than 0 for STOP_LOSS or STOP_LOSS_MARKET order types")
    end
  end

  context "when orderType is LIMIT but price is missing" do
    it "returns an error for price" do
      params = valid_params.merge(orderType: "LIMIT", price: nil)
      result = place_slice_order_validator.call(params)
      expect(result.errors[:price]).to include("is required and must be greater than 0 for LIMIT order types")
    end
  end

  context "when disclosedQuantity exceeds quantity" do
    it "returns an error for disclosedQuantity" do
      params = valid_params.merge(quantity: 10, disclosedQuantity: 15)
      result = place_slice_order_validator.call(params)
      expect(result.errors[:disclosedQuantity]).to include("cannot exceed the total quantity")
    end
  end

  context "when optional fields are valid" do
    it "validates successfully with optional fields" do
      params = valid_params.merge(
        disclosedQuantity: 2,
        price: 100.0,
        triggerPrice: 50.0
      )
      result = place_slice_order_validator.call(params)
      expect(result.success?).to be(true)
    end
  end
end
