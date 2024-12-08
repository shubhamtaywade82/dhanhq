# frozen_string_literal: true

require "spec_helper"

RSpec.describe Dhanhq::Api::Base do
  let(:connection) { instance_double(Faraday::Connection) }
  let(:base_api) { described_class.new(connection: connection) }

  describe "#request" do
    let(:path) { "/test-endpoint" }
    let(:params) { { key: "value" } }
    let(:response) { instance_double(Faraday::Response, status: status, body: response_body) }
    let(:response_body) { { "message" => "success" }.to_json }

    before do
      allow(connection).to receive(:send).and_return(response)
    end

    context "when the response status is 2xx" do
      let(:status) { 200 }

      it "returns the parsed response body" do
        result = base_api.send(:request, :get, path, params)
        expect(result).to eq("message" => "success")
      end
    end

    context "when the response status is 4xx" do
      let(:status) { 400 }
      let(:response_body) { { "message" => "Client error occurred" }.to_json }

      it "raises a ClientError" do
        expect do
          base_api.send(:request, :post, path, params)
        end.to raise_error(Dhanhq::Errors::ClientError, "Client error occurred")
      end
    end

    context "when the response status is 5xx" do
      let(:status) { 500 }
      let(:response_body) { { "message" => "Internal server error" }.to_json }

      it "raises a ServerError" do
        expect do
          base_api.send(:request, :post, path, params)
        end.to raise_error(Dhanhq::Errors::ServerError, "Server error: Internal server error")
      end
    end

    context "when an unexpected status code is returned" do
      let(:status) { 600 }
      let(:response_body) { {}.to_json }

      it "raises a StandardError" do
        expect do
          base_api.send(:request, :post, path, params)
        end.to raise_error(StandardError, "Unexpected response status: 600")
      end
    end

    context "when a connection error occurs" do
      before do
        allow(connection).to receive(:send).and_raise(Faraday::ConnectionFailed.new("Connection error"))
      end

      it "raises a ClientError" do
        expect do
          base_api.send(:request, :get, path, params)
        end.to raise_error(Dhanhq::Errors::ClientError, /Connection error/)
      end
    end
  end

  describe "#json_params" do
    context "when the method is GET" do
      it "returns nil" do
        result = base_api.send(:json_params, :get, { key: "value" })
        expect(result).to be_nil
      end
    end

    context "when the method is not GET" do
      it "returns the parameters as a JSON string" do
        result = base_api.send(:json_params, :post, { key: "value" })
        expect(result).to eq({ key: "value" }.to_json)
      end
    end
  end

  describe "#validate" do
    let(:validator_class) { double("ValidatorClass") }
    let(:validator_instance) { instance_double(Validator) }

    before do
      allow(validator_class).to receive(:new).and_return(validator_instance)
    end

    context "when validation succeeds" do
      before do
        allow(validator_instance).to receive(:call).and_return(instance_double(Dry::Validation::Result,
                                                                               failure?: false))
      end

      it "does not raise an error" do
        expect do
          base_api.send(:validate, { key: "value" }, validator_class)
        end.not_to raise_error
      end
    end

    context "when validation fails" do
      before do
        allow(validator_instance).to receive(:call).and_return(
          instance_double(Dry::Validation::Result, failure?: true, errors: { key: ["is invalid"] })
        )
      end

      it "raises a ValidationError" do
        expect do
          base_api.send(:validate, { key: "value" }, validator_class)
        end.to raise_error(Dhanhq::Errors::ValidationError, { key: ["is invalid"] }.to_s)
      end
    end
  end

  describe "#parse_response" do
    let(:response) { instance_double(Faraday::Response, status: status, body: response_body) }
    let(:response_body) { { "message" => "success" }.to_json }

    context "when the response status is 2xx" do
      let(:status) { 200 }

      it "returns the parsed response body" do
        result = base_api.send(:parse_response, response)
        expect(result).to eq("message" => "success")
      end
    end

    context "when the response body is invalid JSON" do
      let(:response_body) { "invalid json" }
      let(:status) { 200 }

      it "returns an empty hash" do
        result = base_api.send(:parse_response, response)
        expect(result).to eq({})
      end
    end
  end
end
