# frozen_string_literal: true

require "spec_helper"
require "dhanhq/api/orders"

RSpec.describe Dhanhq::Api::Orders do
  let(:params) do
    {
      dhanClientId: "1000000009",
      transactionType: "BUY",
      exchangeSegment: "NSE_EQ",
      productType: "CNC",
      orderType: "LIMIT",
      validity: "DAY",
      securityId: "11536",
      quantity: 5,
      price: 100.0
    }
  end

  before do
    configure_dhanhq
  end

  describe ".place_order" do
    it "makes a successful POST request to place an order" do
      stub_request(:post, "https://api.dhan.co/orders")
        .with(body: params.to_json)
        .to_return(status: 200, body: { orderId: "123456789" }.to_json)

      response = described_class.place_order(params)

      expect(response).to eq({ "orderId" => "123456789" })
    end
  end

  describe ".cancel_order" do
    let(:order_id) { "123456789" }

    it "makes a successful DELETE request to cancel an order" do
      stub_request(:delete, "https://api.dhan.co/orders/#{order_id}")
        .to_return(status: 200, body: { orderId: order_id, status: "CANCELLED" }.to_json)

      response = described_class.cancel_order(order_id)

      expect(response).to eq({ "orderId" => order_id, "status" => "CANCELLED" })
    end
  end

  describe ".orders_list" do
    let(:response_body) do
      [
        {
          "dhanClientId" => "12345",
          "orderId" => "order_1",
          "exchangeOrderId" => "ex_order_1",
          "correlationId" => "corr_1",
          "orderStatus" => "TRADED",
          "transactionType" => "BUY",
          "exchangeSegment" => "NSE_EQ",
          "productType" => "CNC",
          "orderType" => "LIMIT",
          "validity" => "DAY",
          "tradingSymbol" => "RELIANCE",
          "securityId" => "500325",
          "quantity" => 10,
          "disclosedQuantity" => 0,
          "price" => 2500.50,
          "triggerPrice" => 0,
          "afterMarketOrder" => false,
          "boProfitValue" => 0,
          "boStopLossValue" => 0,
          "legName" => "NA",
          "createTime" => "2023-01-01T10:00:00Z",
          "updateTime" => "2023-01-01T10:05:00Z",
          "exchangeTime" => "2023-01-01T10:03:00Z",
          "drvExpiryDate" => "2023-01-31",
          "drvOptionType" => "CALL",
          "drvStrikePrice" => 2600.0,
          "omsErrorCode" => nil,
          "omsErrorDescription" => nil,
          "algoId" => nil,
          "remainingQuantity" => 0,
          "averageTradedPrice" => 2500.5,
          "filledQty" => 10
        }
      ]
    end

    it "makes a successful GET request to retrieve the orders list" do
      stub_request(:get, "https://api.dhan.co/orders")
        .to_return(status: 200, body: response_body.to_json, headers: { "Content-Type" => "application/json" })

      response = described_class.orders_list

      expect(response).to be_an(Array)
      expect(response.size).to eq(1)
      expect(response.first["dhanClientId"]).to eq("12345")
      expect(response.first["orderId"]).to eq("order_1")
      expect(response.first["orderStatus"]).to eq("TRADED")
      expect(response.first["transactionType"]).to eq("BUY")
      expect(response.first["tradingSymbol"]).to eq("RELIANCE")
    end

    it "handles API errors gracefully" do
      stub_request(:get, "https://api.dhan.co/orders")
        .to_return(status: 400, body: { error: "Bad Request" }.to_json)

      expect { described_class.orders_list }.to raise_error(Dhanhq::Errors::ClientError)
    end

    it "handles empty responses" do
      stub_request(:get, "https://api.dhan.co/orders")
        .to_return(status: 200, body: [].to_json, headers: { "Content-Type" => "application/json" })

      response = described_class.orders_list

      expect(response).to be_an(Array)
      expect(response).to be_empty
    end
  end
end
