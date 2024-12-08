# frozen_string_literal: true

require "spec_helper"

RSpec.describe Dhanhq::Validators::BaseValidator do
  it "checks valid transaction types" do
    valid_transaction = described_class.valid_transaction_type.call("BUY")
    invalid_transaction = described_class.valid_transaction_type.call("INVALID")

    expect(valid_transaction).to be(true)
    expect(invalid_transaction).to be(false)
  end

  it "checks valid exchange segments" do
    valid_segment = described_class.valid_exchange_segment.call("NSE_EQ")
    invalid_segment = described_class.valid_exchange_segment.call("INVALID")

    expect(valid_segment).to be(true)
    expect(invalid_segment).to be(false)
  end

  it "checks valid product types" do
    valid_product = described_class.valid_product_type.call("CNC")
    invalid_product = described_class.valid_product_type.call("INVALID")

    expect(valid_product).to be(true)
    expect(invalid_product).to be(false)
  end
end
