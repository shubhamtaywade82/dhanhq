# frozen_string_literal: true

require "dhanhq"

RSpec.describe Dhanhq::Configuration do
  before do
    Dhanhq.configure do |config|
      config.base_url = "http://api.dhan.test.co"
      config.client_id = "test_client_id"
      config.access_token = "test_access_token"
      config.enable_data_api = true
    end
  end

  describe "Configuration" do
    it "retrieves the base_url" do
      expect(Dhanhq.configuration.base_url).to eq("http://api.dhan.test.co")
    end

    it "retrieves the client_id" do
      expect(Dhanhq.configuration.client_id).to eq("test_client_id")
    end

    it "retrieves the access_token" do
      expect(Dhanhq.configuration.access_token).to eq("test_access_token")
    end

    it "retrieves the enable_data_api flag" do
      expect(Dhanhq.configuration.enable_data_api).to be true
    end
  end

  describe "Validation" do
    it "raises an error if client_id is missing" do
      expect do
        Dhanhq.configure { |config| config.client_id = nil }
      end.to raise_error(ArgumentError, "Client ID must be configured")
    end

    it "raises an error if access_token is missing" do
      expect do
        Dhanhq.configure { |config| config.access_token = nil }
      end.to raise_error(ArgumentError, "Access Token must be configured")
    end

    it "does not raise an error if enable_data_api is not set" do
      expect do
        Dhanhq.configure { |config| config.enable_data_api = nil }
      end.not_to raise_error
      expect(Dhanhq.configuration.enable_data_api).to be_nil
    end
  end
end
