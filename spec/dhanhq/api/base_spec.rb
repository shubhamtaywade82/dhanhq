# frozen_string_literal: true

require "spec_helper"
require "dhanhq/api/base"

RSpec.describe Dhanhq::Api::Base do
  let(:mock_connection) { instance_double(Faraday::Connection) }
  let(:mock_response) { instance_double(Faraday::Response) }

  before do
    allow(Dhanhq::Support::FaradayConnection).to receive(:build).and_return(mock_connection)
    # Reset the connection instance before each example
    described_class.instance_variable_set(:@connection, nil)
  end

  describe ".connection" do
    it "returns a Faraday connection instance" do
      expect(described_class.connection).to eq(mock_connection)
    end

    it "reuses the same connection instance" do
      first_connection = described_class.connection
      second_connection = described_class.connection
      expect(first_connection).to equal(second_connection)
    end
  end

  describe ".request" do
    let(:path) { "/test_endpoint" }
    let(:params) { { key: "value" } }

    context "when the response is successful" do
      before do
        allow(mock_response).to receive_messages(status: 200, body: '{"message":"success"}')
        allow(mock_connection).to receive(:post).with(path, params.to_json).and_return(mock_response)
      end

      it "makes a POST request and returns the parsed response" do
        response = described_class.request(:post, path, params)
        expect(response).to eq("message" => "success")
      end
    end

    context "when the response has a client error (4xx)" do
      before do
        allow(mock_response).to receive_messages(status: 400, body: '{"message":"Bad Request"}')
        allow(mock_connection).to receive(:post).with(path, params.to_json).and_return(mock_response)
      end

      it "raises a ClientError with the correct message" do
        expect do
          described_class.request(:post, path, params)
        end.to raise_error(Dhanhq::Errors::ClientError, "Bad Request")
      end
    end

    context "when the response has a server error (5xx)" do
      before do
        allow(mock_response).to receive_messages(status: 500, body: '{"error":"Internal Error","message":"Server Failure"}')
        allow(mock_connection).to receive(:post).with(path, params.to_json).and_return(mock_response)
      end

      it "raises a ServerError with the correct message" do
        expect do
          described_class.request(:post, path, params)
        end.to raise_error(Dhanhq::Errors::ServerError, "Server Error: 500 - Internal Error: Server Failure")
      end
    end

    context "when there is a connection error" do
      before do
        allow(mock_connection).to receive(:post).and_raise(Faraday::ConnectionFailed, "Connection failed")
      end

      it "raises a ClientError with the correct message" do
        expect do
          described_class.request(:post, path, params)
        end.to raise_error(Dhanhq::Errors::ClientError, "Connection error: Connection failed")
      end
    end
  end

  describe ".parse_response" do
    let(:response) { instance_double(Faraday::Response) }

    context "when the response status is 200" do
      it "returns the parsed JSON body" do
        allow(response).to receive_messages(status: 200, body: '{"key":"value"}')
        result = described_class.send(:parse_response, response)
        expect(result).to eq("key" => "value")
      end
    end

    context "when the response body is invalid JSON" do
      it "returns an empty hash" do
        allow(response).to receive_messages(status: 200, body: "invalid_json")
        result = described_class.send(:parse_response, response)
        expect(result).to eq({})
      end
    end

    context "when the response is nil" do
      it "raises a standard error for unexpected nil response" do
        allow(response).to receive_messages(status: nil, body: nil)
        expect do
          described_class.send(:parse_response, response)
        end.to raise_error(StandardError, /Unexpected response status/)
      end
    end
  end

  describe ".validate" do
    let(:validator_class) do
      Class.new(Dry::Validation::Contract) do
        params do
          required(:key).filled(:string)
        end
      end
    end

    context "when validation passes" do
      it "does not raise an error" do
        expect do
          described_class.send(:validate, { key: "value" }, validator_class)
        end.not_to raise_error
      end
    end

    context "when validation fails" do
      it "raises a ValidationError with details" do
        expect do
          described_class.send(:validate, { key: nil }, validator_class)
        end.to raise_error(Dhanhq::Errors::ValidationError, /key/)
      end
    end
  end
end
