require 'gist'

module Woro
  module Adapters
    class Gist

      attr_reader :gist_id

      # Create a new gist collection adapter
      # @param gist_id [String] gist to which the adapter connects
      def initialize(gist_id)
        @gist_id = gist_id
      end

      # Returns the list of files included in the Gist
      # @return [Hash] List of files in the format { filename: { data }}
      def list_keys
        gist['files']
      end

      # Push this task's file content to the Gist collection on the server.
      # Existing contents by the same #file_name will be overriden, but
      # can be accessed via Github or Gist's API.
      def push(task)
        ::Gist.multi_gist({ task.file_name => task.read_task_file },
                        public: false,
                        update: gist_id,
                        output: :all)
      end

      # The Gist contains a collection of files.
      # These are stored and accessed on Github.
      # @return [Hash] parsed JSON hash of the gist's metadata
      def gist
        @gist ||= retrieve_gist(gist_id)
      end

      # Retrieves metadata of the specified gist
      # @param gist_id [String] id of the gist
      # @return [Hash] parsed JSON hash
      def retrieve_gist(gist_id)
        service_url = "https://api.github.com/gists/#{gist_id}"
        response = Net::HTTP.get_response(URI.parse(service_url))
        JSON.parse(response.body || '')
      end

      # Retrieves the data hash included in the gist under the #file_name.
      # @param file_name [String] name of the file to retrieve the download url
      # @return [Hash] parsed JSON hash
      def retrieve_file_data(file_name)
        gist['files'][file_name]
      end

      # The raw url is a permalink for downloading the content rake task within
      # the Gist as a file.
      # @param file_name [String] name of the file to retrieve the download url
      # @return [String] HTTP-URL of addressed file within the gist collection
      def raw_url(file_name)
        retrieve_file_data(file_name)['raw_url']
      end

      # Creates an initial welcome gist on project setup
      # @param app_name [String] Name of the app is displayed in the initial welcome message
      def create_initial_remote_task(app_name, access_token=nil)
        Gist.gist("Welcome to the Woro Task Repository for #{app_name}", filename: app_name, access_token: access_token)
      end

      # Extract description from gist's data content string.
      # @param data [Hash] gist data hash
      # [String] description string
      def extract_description(data)
        data['content'].match(/desc ['"]([a-zA-Z0-9\s]*)['"]/)[1]
      end

      # Read the rake task template
      # @return [String]
      def read_template_file
        File.read(File.join(File.dirname(__FILE__), 'templates','task.rake') )
      end
    end
  end
end
