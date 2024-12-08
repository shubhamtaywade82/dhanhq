# frozen_string_literal: true

require "spec_helper"
require "dhanhq/api/funds"

RSpec.describe Dhanhq::Api::Funds do
  before do
    configure_dhanhq
  end

  describe ".fund_limit" do
    it "makes a successful GET request to retrieve fund limits" do
      stub_request(:get, "http://api.dhan.test.co/fundlimit")
        .to_return(status: 200, body: { availableBalance: 5000.0 }.to_json)

      response = described_class.fund_limit

      expect(response).to eq({ "availableBalance" => 5000.0 })
    end
  end

  describe ".calculate_margin" do
    let(:params) do
      {
        dhanClientId: "1000000132",
        exchangeSegment: "NSE_EQ",
        transactionType: "BUY",
        quantity: 5,
        productType: "CNC",
        securityId: "1333",
        price: 1428
      }
    end

    it "makes a successful POST request to calculate margin" do
      stub_request(:post, "http://api.dhan.test.co/margincalculator")
        .with(body: params.to_json)
        .to_return(status: 200, body: { totalMargin: 1000.0 }.to_json)

      response = described_class.calculate_margin(params)

      expect(response).to eq({ "totalMargin" => 1000.0 })
    end
  end
end
