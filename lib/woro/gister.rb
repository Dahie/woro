require 'gist'
require 'net/https'

# All classes and modules specific to Woro.
module Woro
  # Various shared static helpers
  class Gister
    class << self
      # Creates an initial welcome gist on project setup
      # @param app_name [String] Name of the app is displayed in the initial welcome message
      def create_initial_gist(app_name)
        Gist.gist("Welcome to the Woro Task Repository for #{app_name}", filename: app_name)
      end

      # Retrieves metadata of the specified gist
      # @param gist_id [String] id of the gist
      # @return [Hash] parsed JSON hash
      def retrieve_gist(gist_id)
        service_url = "https://api.github.com/gists/#{gist_id}"
        response = Net::HTTP.get_response(URI.parse(service_url))
        JSON.parse(response.body)
      end

      # Extract description from gist's data content string.
      # @param data [Hash] gist data hash
      # [String] description string
      def extract_description(data)
        data['content'].match(/desc ['"]([a-zA-Z0-9\s]*)['"]/)[1]
      end

      # Returns the list of files included in the specified gist
      # @param gist_id [String] id of the gist
      # @return [Hash] List of files in the format { filename: { data }}
      def get_list_of_files(gist_id)
        retrieve_gist(gist_id)['files']
      end

      # Read the rake task template
      # @return [String]
      def read_template_file
        File.read(File.dirname(__FILE__) +"/templates/task.rake")
      end
    end
  end
end
