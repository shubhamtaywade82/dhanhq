# frozen_string_literal: true

require "spec_helper"
require "dhanhq/client"

RSpec.describe Dhanhq::Client do
  before do
    configure_dhanhq
  end

  let(:client) { described_class.new }

  describe "#request" do
    let(:endpoint) { "/orders" }
    let(:response_body) { { orders: [] }.to_json }

    it "makes a successful GET request" do
      stub_request(:get, "http://api.dhan.test.co/orders")
        .to_return(status: 200, body: response_body, headers: { "Content-Type" => "application/json" })

      response = client.request(:get, endpoint)

      expect(response).to eq(JSON.parse(response_body))
    end

    it "raises an error for a failed request" do
      stub_request(:get, "http://api.dhan.test.co/orders")
        .to_return(status: 400, body: { error: "Bad Request" }.to_json)

      expect { client.request(:get, endpoint) }.to raise_error(Dhanhq::Error)
    end
  end
end
