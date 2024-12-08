# frozen_string_literal: true

require "spec_helper"
require_relative "../../../../lib/dhanhq/validators/forever_orders/modify_forever_order_validator"
require_relative "../../../../lib/dhanhq/constants"

RSpec.describe Dhanhq::Validators::ForeverOrders::ModifyForeverOrderValidator do
  subject(:modify_forever_order_validator) { described_class.new }

  let(:valid_params) do
    {
      dhanClientId: "client_123",
      orderId: "order_456",
      orderFlag: "SINGLE",
      orderType: "LIMIT",
      legName: "ENTRY_LEG",
      quantity: 10,
      price: 1428,
      triggerPrice: 1427,
      validity: "DAY"
    }
  end

  context "when all required fields are valid" do
    it "validates successfully" do
      result = modify_forever_order_validator.call(valid_params)
      expect(result.success?).to eq(true)
    end
  end

  context "when orderId is missing" do
    it "returns an error for orderId" do
      params = valid_params.merge(orderId: nil)
      result = modify_forever_order_validator.call(params)
      expect(result.errors[:orderId]).to include("must be filled")
    end
  end
end
