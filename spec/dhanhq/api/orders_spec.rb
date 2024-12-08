# frozen_string_literal: true

require "spec_helper"

RSpec.describe Dhanhq::Api::Orders do
  let(:connection) { instance_double(Faraday::Connection) }
  let(:orders_api) { described_class.new(connection: connection) }

  describe "#place_order" do
    let(:params) do
      {
        dhanClientId: "client_123",
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

    it "places a new order successfully" do
      response_body = { orderId: "123456", orderStatus: "PENDING" }.to_json
      allow(connection).to receive(:post).and_return(double(body: response_body, status: 200))

      response = orders_api.place_order(params)
      expect(response["orderId"]).to eq("123456")
      expect(response["orderStatus"]).to eq("PENDING")
    end

    it "raises validation error for invalid params" do
      params[:transactionType] = "INVALID"
      expect do
        orders_api.place_order(params)
      end.to raise_error(Dhanhq::Errors::ValidationError)
    end
  end

  describe "#modify_order" do
    let(:order_id) { "112111182045" }
    let(:params) do
      {
        dhanClientId: "client_123",
        orderType: "LIMIT",
        quantity: 10,
        price: 120.0,
        validity: "DAY"
      }
    end

    it "modifies an existing order successfully" do
      response_body = { orderId: order_id, orderStatus: "TRANSIT" }.to_json
      allow(connection).to receive(:put).and_return(double(body: response_body, status: 200))

      response = orders_api.modify_order(order_id, params)
      expect(response["orderId"]).to eq(order_id)
      expect(response["orderStatus"]).to eq("TRANSIT")
    end
  end

  describe "#cancel_order" do
    let(:order_id) { "112111182045" }

    it "cancels an order successfully" do
      response_body = { orderId: order_id, orderStatus: "CANCELLED" }.to_json
      allow(connection).to receive(:delete).and_return(double(body: response_body, status: 200))

      response = orders_api.cancel_order(order_id)
      expect(response["orderId"]).to eq(order_id)
      expect(response["orderStatus"]).to eq("CANCELLED")
    end
  end

  describe "#slice_order" do
    let(:params) do
      {
        dhanClientId: "client_123",
        transactionType: "BUY",
        exchangeSegment: "NSE_EQ",
        productType: "CNC",
        orderType: "LIMIT",
        validity: "DAY",
        securityId: "11536",
        quantity: 1000,
        price: 100.0
      }
    end

    it "slices an order successfully" do
      response_body = [
        { orderId: "123456", orderStatus: "TRANSIT" },
        { orderId: "123457", orderStatus: "TRANSIT" }
      ].to_json

      allow(connection).to receive(:post).and_return(double(body: response_body, status: 200))

      response = orders_api.slice_order(params)
      expect(response.size).to eq(2)
      expect(response.first["orderId"]).to eq("123456")
    end
  end

  describe "#order_book" do
    it "retrieves the order book successfully" do
      response_body = [
        { orderId: "123456", orderStatus: "PENDING" },
        { orderId: "123457", orderStatus: "CANCELLED" }
      ].to_json

      allow(connection).to receive(:get).and_return(double(body: response_body, status: 200))

      response = orders_api.order_book
      expect(response.size).to eq(2)
      expect(response.first["orderId"]).to eq("123456")
    end
  end

  describe "#order_details" do
    let(:order_id) { "112111182045" }

    it "retrieves details of an order successfully" do
      response_body = { orderId: order_id, orderStatus: "PENDING" }.to_json
      allow(connection).to receive(:get).and_return(double(body: response_body, status: 200))

      response = orders_api.order_details(order_id)
      expect(response["orderId"]).to eq(order_id)
      expect(response["orderStatus"]).to eq("PENDING")
    end
  end

  describe "#order_by_correlation_id" do
    let(:correlation_id) { "123abc678" }

    it "retrieves details of an order by correlation ID successfully" do
      response_body = { orderId: "123456", correlationId: correlation_id, orderStatus: "PENDING" }.to_json
      allow(connection).to receive(:get).and_return(double(body: response_body, status: 200))

      response = orders_api.order_by_correlation_id(correlation_id)
      expect(response["orderId"]).to eq("123456")
      expect(response["correlationId"]).to eq(correlation_id)
    end
  end

  describe "#trade_book" do
    it "retrieves the trade book successfully" do
      response_body = [
        { orderId: "123456", tradedQuantity: 10 },
        { orderId: "123457", tradedQuantity: 20 }
      ].to_json

      allow(connection).to receive(:get).and_return(double(body: response_body, status: 200))

      response = orders_api.trade_book
      expect(response.size).to eq(2)
      expect(response.first["tradedQuantity"]).to eq(10)
    end
  end

  describe "#trade_details" do
    let(:order_id) { "112111182045" }

    it "retrieves trade details of an order successfully" do
      response_body = { orderId: order_id, tradedQuantity: 40 }.to_json
      allow(connection).to receive(:get).and_return(double(body: response_body, status: 200))

      response = orders_api.trade_details(order_id)
      expect(response["orderId"]).to eq(order_id)
      expect(response["tradedQuantity"]).to eq(40)
    end
  end
end
