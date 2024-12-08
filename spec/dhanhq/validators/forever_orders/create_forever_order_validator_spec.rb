# frozen_string_literal: true

require "spec_helper"
require_relative "../../../../lib/dhanhq/validators/forever_orders/create_forever_order_validator"
require_relative "../../../../lib/dhanhq/constants"

RSpec.describe Dhanhq::Validators::ForeverOrders::CreateForeverOrderValidator do
  subject(:create_forever_order_validator) { described_class.new }

  let(:valid_params) do
    {
      dhanClientId: "client_123",
      orderFlag: "SINGLE",
      transactionType: "BUY",
      exchangeSegment: "NSE_EQ",
      productType: "CNC",
      orderType: "LIMIT",
      validity: "DAY",
      securityId: "1333",
      quantity: 5,
      price: 1428,
      triggerPrice: 1427
    }
  end

  context "when all required fields are valid" do
    it "validates successfully" do
      result = create_forever_order_validator.call(valid_params)
      expect(result.success?).to eq(true)
    end
  end

  context "when orderFlag is OCO but price1, triggerPrice1, or quantity1 is missing" do
    it "returns errors for missing fields" do
      params = valid_params.merge(orderFlag: "OCO", price1: nil, triggerPrice1: nil, quantity1: nil)
      result = create_forever_order_validator.call(params)
      expect(result.errors[:price1]).to include("is required for OCO orders")
      expect(result.errors[:triggerPrice1]).to include("is required for OCO orders")
      expect(result.errors[:quantity1]).to include("is required for OCO orders")
    end
  end

  context "when transactionType is invalid" do
    it "returns an error for transactionType" do
      params = valid_params.merge(transactionType: "INVALID")
      result = create_forever_order_validator.call(params)
      expect(result.errors[:transactionType]).to include("must be one of: #{Dhanhq::Constants::TRANSACTION_TYPES.join(', ')}")
    end
  end
end
