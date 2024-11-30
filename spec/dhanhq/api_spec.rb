# frozen_string_literal: true

RSpec.describe Dhanhq::API do
  subject(:dhan_api) { described_class.new }

  before do
    Dhanhq.configure do |config|
      config.base_url = "https://api.dhan.co"
      config.client_id = "test_client_id"
      config.access_token = "test_access_token"
    end
  end

  describe "#order_list" do
    it "retrieves the order list successfully" do
      VCR.use_cassette("order_list") do
        response = dhan_api.order_list
        expect(response).to be_a(Hash)
        expect(response["status"]).to eq("success")
      end
    end
  end

  describe "#place_order" do
    it "places an order successfully" do
      VCR.use_cassette("place_order") do
        order_params = {
          securityId: "123456",
          transactionType: "BUY",
          quantity: 10,
          price: 100.0,
          productType: "CNC",
          orderType: "LIMIT",
          validity: "DAY"
        }

        response = dhan_api.place_order(order_params)
        expect(response).to be_a(Hash)
        expect(response["status"]).to eq("success")
      end
    end

    it "handles invalid order parameters" do
      VCR.use_cassette("place_order_invalid") do
        order_params = {
          securityId: "",
          transactionType: "BUY",
          quantity: 0,
          price: 0.0,
          productType: "CNC",
          orderType: "LIMIT",
          validity: "DAY"
        }

        response = dhan_api.place_order(order_params)
        expect(response["status"]).to eq("failure")
        expect(response["remarks"]["error_message"]).to include("Invalid securityId")
      end
    end
  end
end
