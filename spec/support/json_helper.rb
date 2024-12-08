# frozen_string_literal: true

module JsonHelper
  # Loads a JSON file and parses it into a Ruby hash
  #
  # @param file_path [String] The relative path to the JSON file
  # @return [Hash, Array] The parsed JSON content
  def load_json(file_path)
    file_path = "spec/mocks/#{file_path}"
    JSON.parse(File.read(file_path))
  rescue Errno::ENOENT
    raise "JSON file not found: #{file_path}"
  rescue JSON::ParserError
    raise "Invalid JSON format in file: #{file_path}"
  end
end
