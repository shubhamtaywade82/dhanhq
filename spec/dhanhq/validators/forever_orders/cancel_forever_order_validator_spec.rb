# frozen_string_literal: true

require "spec_helper"
require_relative "../../../../lib/dhanhq/validators/forever_orders/cancel_forever_order_validator"

RSpec.describe Dhanhq::Validators::ForeverOrders::CancelForeverOrderValidator do
  subject(:cancel_forever_order_validator) { described_class.new }

  let(:valid_params) { { orderId: "order_456" } }

  context "when orderId is present" do
    it "validates successfully" do
      result = cancel_forever_order_validator.call(valid_params)
      expect(result.success?).to be(true)
    end
  end

  context "when orderId is missing" do
    it "returns an error for orderId" do
      params = valid_params.merge(orderId: nil)
      result = cancel_forever_order_validator.call(params)
      expect(result.errors[:orderId]).to include("must be filled")
    end
  end
end
