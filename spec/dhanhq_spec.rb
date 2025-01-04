# frozen_string_literal: true

RSpec.describe Dhanhq do
  it "has a version number" do
    expect(Dhanhq::VERSION).not_to be_nil
  end

  it "allows configuration" do
    described_class.configure do |config|
      config.access_token = "test_token"
      config.client_id = "test_client_id"
    end

    expect(Dhanhq::Config.access_token).to eq("test_token")
    expect(Dhanhq::Config.client_id).to eq("test_client_id")
  end

  it "resets configuration" do
    described_class.configure do |config|
      config.access_token = "test_token"
      config.client_id = "test_client_id"
    end

    Dhanhq::Config.reset

    expect(Dhanhq::Config.access_token).to be_nil
    expect(Dhanhq::Config.client_id).to be_nil
  end
end
