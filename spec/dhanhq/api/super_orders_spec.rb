# frozen_string_literal: true

require "spec_helper"

RSpec.describe Dhanhq::API::SuperOrders do
  let(:base_url) { "https://api.dhan.co/v2/super/orders" }

  before do
    Dhanhq.configure do |config|
      config.access_token = "mock-token"
      config.client_id = "1000000003"
    end
  end

  describe ".place" do
    let(:params) do
      {
        transactionType: "BUY",
        exchangeSegment: "NSE_EQ",
        productType: "CNC",
        orderType: "LIMIT",
        securityId: "11536",
        quantity: 5,
        price: 1500.0,
        targetPrice: 1600.0,
        stopLossPrice: 1400.0,
        trailingJump: 10.0
      }
    end

    it "successfully places a super order with stubbed response" do
      full_params = params.merge(dhanClientId: "1000000003")

      stub_request(:post, base_url)
        .with(
          body: JSON.generate(full_params),
          headers: {
            "access-token" => "mock-token",
            "client-id" => "1000000003",
            "content-type" => "application/json"
          }
        )
        .to_return(
          status: 200,
          body: { orderId: "112111182198", orderStatus: "PENDING" }.to_json,
          headers: { "Content-Type" => "application/json" } # ✅ THIS IS CRITICAL
        )

      response = described_class.place(params)
      expect(response[:orderId]).to eq("112111182198")
      expect(response[:orderStatus]).to eq("PENDING")
    end
  end

  describe ".modify" do
    let(:order_id) { "112111182045" }
    let(:params) do
      {
        legName: "ENTRY_LEG",
        orderType: "LIMIT",
        quantity: 10,
        price: 1300.0,
        targetPrice: 1350.0,
        stopLossPrice: 1250.0,
        trailingJump: 5.0
      }
    end

    it "successfully modifies a super order" do
      full_params = params.merge(orderId: order_id, dhanClientId: "1000000003")

      stub_request(:put, "#{base_url}/#{order_id}")
        .with(
          body: full_params,
          headers: {
            "access-token" => "mock-token",
            "client-id" => "1000000003",
            "content-type" => "application/json"
          }
        )
        .to_return(
          status: 200,
          body: { orderId: order_id, orderStatus: "TRANSIT" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )

      response = described_class.modify(order_id, params)
      expect(response[:orderStatus]).to eq("TRANSIT")
    end
  end

  describe ".cancel" do
    let(:order_id) { "112111182045" }
    let(:leg) { "STOP_LOSS_LEG" }

    it "successfully cancels a super order leg" do
      stub_request(:delete, "#{base_url}/#{order_id}/#{leg}")
        .to_return(
          status: 200,
          body: { orderId: order_id, orderStatus: "CANCELLED" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )

      response = described_class.cancel(order_id, leg)
      expect(response[:orderStatus]).to eq("CANCELLED")
    end
  end

  describe ".list" do
    it "retrieves a list of super orders" do
      stub_request(:get, base_url)
        .to_return(
          status: 200,
          body: [
            {
              orderId: "123",
              dhanClientId: "1100003626",
              orderStatus: "PENDING",
              legDetails: []
            }
          ].to_json,
          headers: { "Content-Type" => "application/json" }
        )

      response = described_class.list
      expect(response).to be_an(Array)
      expect(response.first["orderStatus"]).to eq("PENDING")
    end
  end
end
