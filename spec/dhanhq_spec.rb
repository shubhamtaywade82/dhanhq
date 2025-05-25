# frozen_string_literal: true

# spec/dhanhq_spec.rb
require "spec_helper"

RSpec.describe Dhanhq do
  it "has a version number" do
    expect(Dhanhq::VERSION).not_to be_nil
  end

  it "allows configuration" do
    described_class.configure do |config|
      config.access_token = "test_token"
      config.client_id = "test_client"
    end

    expect(described_class.configuration.access_token).to eq("test_token")
    expect(described_class.configuration.client_id).to eq("test_client")
  end

  it "resets configuration" do
    described_class.configuration.access_token = nil
    described_class.configuration.client_id = nil

    expect(described_class.configuration.access_token).to be_nil
    expect(described_class.configuration.client_id).to be_nil
  end
end
