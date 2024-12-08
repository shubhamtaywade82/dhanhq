# frozen_string_literal: true

require "spec_helper"
require_relative "../../../../lib/dhanhq/validators/portfolio/convert_position_validator"
require_relative "../../../../lib/dhanhq/constants"

RSpec.describe Dhanhq::Validators::Portfolio::ConvertPositionValidator do
  subject(:convert_position_validator) { described_class.new }

  let(:valid_params) do
    {
      dhanClientId: "client_123",
      fromProductType: "INTRADAY",
      exchangeSegment: "NSE_EQ",
      positionType: "LONG",
      securityId: "11536",
      convertQty: 40,
      toProductType: "CNC"
    }
  end

  context "when all required fields are valid" do
    it "validates successfully" do
      result = convert_position_validator.call(valid_params)
      expect(result.success?).to be(true)
    end
  end

  context "when fromProductType and toProductType are the same" do
    it "returns an error" do
      params = valid_params.merge(fromProductType: "CNC", toProductType: "CNC")
      result = convert_position_validator.call(params)
      expect(result.errors[:toProductType]).to include("must be different from fromProductType")
    end
  end

  context "when convertQty is less than or equal to 0" do
    it "returns an error" do
      params = valid_params.merge(convertQty: 0)
      result = convert_position_validator.call(params)
      expect(result.errors[:convertQty]).to include("must be greater than 0")
    end
  end
end
