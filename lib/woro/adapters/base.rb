module Woro
  module Adapters
    class Base

      # Extract description from file content string.
      # @param content [String] content of task file
      # [String] description string
      def extract_description(content)
        Woro::TaskHelper.extract_description content
      end

      # Returns the list of files included in the Gist
      # @return [Array] List of file names
      def list_files
      end

      # Returns the list of files included in the Gist
      # @return [Hash] List of files in the format { filename: { data }}
      def list_contents
      end

      # Push this task's file content to the Gist collection on the server.
      # Existing contents by the same #file_name will be overriden, but
      # can be accessed via Github or Gist's API.
      def push(task)
      end

      # Creates an initial welcome gist on project setup
      # @param app_name [String] Name of the app is displayed in the
      # initial welcome message
      def self.create_initial_remote_task(app_name, access_token = nil)
        # not implemented
      end

      # The raw url is a permalink for downloading the content rake task within
      # the Gist as a file.
      # @param file_name [String] name of the file to retrieve the download url
      # @return [String] HTTP-URL of addressed file within the gist collection
      def raw_url(file_name)
      end

    end
  end
end
