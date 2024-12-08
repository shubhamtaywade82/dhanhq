# frozen_string_literal: true

require "spec_helper"
require "dhanhq/support/faraday_connection"

RSpec.describe Dhanhq::Support::FaradayConnection do
  let(:connection) { described_class.build }

  before do
    configure_dhanhq
  end

  it "creates a Faraday connection" do
    expect(connection).to be_a(Faraday::Connection)
  end

  it "sets the correct headers" do
    headers = connection.headers
    expect(headers["Content-Type"]).to eq("application/json")
    expect(headers["access-token"]).to eq("test_access_token")
    expect(headers["client-id"]).to eq("test_client_id")
  end

  it "parses JSON responses automatically" do
    expect(connection.builder.handlers).to include(FaradayMiddleware::ParseJson)
  end
end
