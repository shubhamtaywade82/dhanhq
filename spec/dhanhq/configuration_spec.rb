# frozen_string_literal: true

require "dhanhq"

RSpec.describe Dhanhq::Configuration do
  before do
    Dhanhq.configure do |config|
      config.base_url = "https://api.dhan.co"
      config.client_id = "test_client_id"
      config.access_token = "test_access_token"
    end
  end

  describe "Configuration" do
    it "sets and retrieves the base_url" do
      expect(Dhanhq.configuration.base_url).to eq("https://api.dhan.co")
    end

    it "sets and retrieves the client_id" do
      expect(Dhanhq.configuration.client_id).to eq("test_client_id")
    end

    it "sets and retrieves the access_token" do
      expect(Dhanhq.configuration.access_token).to eq("test_access_token")
    end

    it "raises error if base_url is not configured" do
      Dhanhq.configure { |config| config.base_url = nil }
      expect(Dhanhq.configuration.base_url).to be_nil
    end

    it "raises error if client_id is missing" do
      Dhanhq.configure { |config| config.client_id = nil }
      expect(Dhanhq.configuration.client_id).to be_nil
    end

    it "raises error if access_token is missing" do
      Dhanhq.configure { |config| config.access_token = nil }
      expect(Dhanhq.configuration.access_token).to be_nil
    end
  end
end
