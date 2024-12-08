# frozen_string_literal: true

RSpec.describe Dhanhq::Api::Base do
  include DhanhqHelper

  let(:client) { instance_double(Dhanhq::Client) }
  let(:method) { :get }
  let(:endpoint) { "/test_endpoint" }
  let(:params) { { key: "value" } }
  let(:response_body) { { data: "test response" } }

  before do
    configure_dhanhq
    allow(described_class).to receive(:client).and_return(client)
    allow(client).to receive(:request).and_return(response_body)
  end

  describe ".client" do
    it "returns a shared client instance" do
      expect(described_class.client).to eq(client)
    end
  end

  describe ".request" do
    context "when Data API access is disabled and endpoint is data-related" do
      let(:endpoint) { "/marketfeed/ltp" }

      before do
        allow(Dhanhq.configuration).to receive(:enable_data_api).and_return(false)
      end

      it "raises an error" do
        expect do
          described_class.request(method, endpoint, params)
        end.to raise_error("Data API access is disabled")
      end
    end

    context "when Data API access is enabled" do
      before do
        allow(Dhanhq.configuration).to receive(:enable_data_api).and_return(true)
      end

      it "makes a successful request and returns the response" do
        result = described_class.request(method, endpoint, params)
        expect(result).to eq(response_body)
      end

      it "handles errors from the client" do
        allow(client).to receive(:request).and_raise(Dhanhq::Error.new(status: 400, body: "Bad Request"))

        expect do
          described_class.request(method, endpoint, params)
        end.to raise_error(Dhanhq::Errors::ClientError, /Client Error: 400/)
      end
    end
  end

  describe ".validate_params!" do
    let(:schema) do
      Class.new(Dry::Validation::Contract) do
        params do
          required(:key).filled(:string)
        end
      end
    end

    context "when parameters are valid" do
      it "does not raise an error" do
        expect do
          described_class.validate_params!(params, schema)
        end.not_to raise_error
      end
    end

    context "when parameters are invalid" do
      let(:invalid_params) { { key: nil } }

      it "raises a ValidationError" do
        expect do
          described_class.validate_params!(invalid_params, schema)
        end.to raise_error(Dhanhq::Errors::ValidationError, /key/)
      end
    end
  end

  describe ".handle_error" do
    let(:error) { instance_double(Dhanhq::Error, status: status, body: "Test Error") }

    context "when error is client-side (400-499)" do
      let(:status) { 400 }

      it "raises a ClientError" do
        expect do
          described_class.send(:handle_error, error)
        end.to raise_error(Dhanhq::Errors::ClientError, /Client Error: 400/)
      end
    end

    context "when error is server-side (500-599)" do
      let(:status) { 500 }

      it "raises a ServerError" do
        expect do
          described_class.send(:handle_error, error)
        end.to raise_error(Dhanhq::Errors::ServerError, /Server Error: 500/)
      end
    end

    context "when error is unexpected" do
      let(:status) { 300 }

      it "raises a generic ApiError" do
        expect do
          described_class.send(:handle_error, error)
        end.to raise_error(Dhanhq::Errors::ApiError, /Unexpected Error: 300/)
      end
    end
  end
end
