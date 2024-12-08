# frozen_string_literal: true

require "spec_helper"
require_relative "../../../../lib/dhanhq/validators/orders/modify_order_validator"
require_relative "../../../../lib/dhanhq/constants"

RSpec.describe Dhanhq::Validators::Orders::ModifyOrderValidator do
  subject(:modify_order_validator) { described_class.new }

  let(:valid_params) do
    {
      dhanClientId: "client_123",
      orderId: "order_456",
      orderType: Dhanhq::Constants::ORDER_TYPES.first, # "LIMIT"
      validity: Dhanhq::Constants::VALIDITY_TYPES.first, # "DAY"
      quantity: 10,
      price: 100.0
    }
  end

  context "when all required fields are valid" do
    it "validates successfully" do
      result = modify_order_validator.call(valid_params)
      expect(result.success?).to be(true)
    end
  end

  context "when dhanClientId is missing" do
    it "returns an error for dhanClientId" do
      params = valid_params.merge(dhanClientId: nil)
      result = modify_order_validator.call(params)
      expect(result.errors[:dhanClientId]).to include("must be filled")
    end
  end

  context "when orderId is missing" do
    it "returns an error for orderId" do
      params = valid_params.merge(orderId: nil)
      result = modify_order_validator.call(params)
      expect(result.errors[:orderId]).to include("must be filled")
    end
  end

  context "when orderType is invalid" do
    it "returns an error for orderType" do
      params = valid_params.merge(orderType: "INVALID")
      result = modify_order_validator.call(params)
      expect(result.errors[:orderType]).to include("must be one of: #{Dhanhq::Constants::ORDER_TYPES.join(", ")}")
    end
  end

  context "when triggerPrice is required but missing" do
    it "returns an error for triggerPrice when orderType is STOP_LOSS" do
      params = valid_params.merge(orderType: "STOP_LOSS", triggerPrice: nil)
      result = modify_order_validator.call(params)

      expect(result.errors[:triggerPrice]).to include("is required for STOP_LOSS or STOP_LOSS_MARKET order types")
    end
  end

  context "when quantity is invalid" do
    it "returns an error for quantity when it is less than or equal to 0" do
      params = valid_params.merge(quantity: 0)
      result = modify_order_validator.call(params)

      expect(result.errors[:quantity]).to include("must be greater than 0")
    end
  end

  context "when validity is invalid" do
    it "returns an error for validity" do
      params = valid_params.merge(validity: "INVALID")
      result = modify_order_validator.call(params)
      expect(result.errors[:validity]).to include("must be one of: #{Dhanhq::Constants::VALIDITY_TYPES.join(", ")}")
    end
  end

  context "when optional fields are valid" do
    it "validates successfully with optional fields" do
      params = valid_params.merge(
        legName: "ENTRY_LEG",
        disclosedQuantity: 5,
        triggerPrice: 50.0
      )
      result = modify_order_validator.call(params)
      expect(result.success?).to be(true)
    end
  end
end
