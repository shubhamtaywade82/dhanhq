# frozen_string_literal: true

require "spec_helper"
require_relative "../../../../lib/dhanhq/validators/funds/margin_calculator_validator"
require_relative "../../../../lib/dhanhq/constants"

RSpec.describe Dhanhq::Validators::Funds::MarginCalculatorValidator do
  subject(:margin_calculator_validator) { described_class.new }

  let(:valid_params) do
    {
      dhanClientId: "client_123",
      exchangeSegment: "NSE_EQ",
      transactionType: "BUY",
      quantity: 5,
      productType: "CNC",
      securityId: "1333",
      price: 1428.0,
      triggerPrice: nil
    }
  end

  context "when all required fields are valid" do
    it "validates successfully" do
      result = margin_calculator_validator.call(valid_params)
      expect(result.success?).to be(true)
    end
  end

  # context "when transactionType requires a triggerPrice but it's missing" do
  #   it "returns an error for triggerPrice" do
  #     params = valid_params.merge(transactionType: "BUY", triggerPrice: 0)
  #     result = margin_calculator_validator.call(params)

  #     pp result

  #     expect(result.errors[:triggerPrice]).to include("is required and must be greater than 0 for BUY or SELL transaction types")
  #   end
  # end

  # context "when transactionType requires a triggerPrice but it's invalid" do
  #   it "returns an error for triggerPrice" do
  #     params = valid_params.merge(transactionType: "SELL", triggerPrice: 0.0)
  #     result = margin_calculator_validator.call(params)

  #     expect(result.errors[:triggerPrice]).to include("is required and must be greater than 0 for BUY or SELL transaction types")
  #   end
  # end

  context "when quantity is less than or equal to 0" do
    it "returns an error for quantity" do
      params = valid_params.merge(quantity: 0)
      result = margin_calculator_validator.call(params)
      expect(result.errors[:quantity]).to include("must be greater than 0")
    end
  end

  context "when price is less than or equal to 0" do
    it "returns an error for price" do
      params = valid_params.merge(price: 0.0)
      result = margin_calculator_validator.call(params)
      expect(result.errors[:price]).to include("must be greater than 0")
    end
  end

  context "when triggerPrice is provided for a non-SL transactionType" do
    it "does not return an error" do
      params = valid_params.merge(transactionType: "BUY", triggerPrice: 1500.0)
      result = margin_calculator_validator.call(params)
      expect(result.success?).to be(true)
    end
  end
end
