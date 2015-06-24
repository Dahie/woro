require 'net/ftp'
module Woro
  module Adapters
    class Ftp < Base
      attr_accessor :host, :user, :password, :folder

      def initialize(options)
        self.host = options['host']
        self.user = options['user']
        self.password = options['password']
        self.folder = options['folder'] || '/'
      end

      # Returns the list of rake files included in the remote collection
      # @return [Array] List of files
      def list_files
        [].tap do |files|
          client do |ftp|
            ftp.chdir(folder)
            ftp.nlst.each do |file|
              files << file if file.include?('.rake')
            end
          end
        end
      end

      def list_contents
        {}.tap do |files|
          client do |ftp|
            ftp.chdir(folder)
            ftp.nlst.each do |file|
              next unless file.include?('.rake')
              ftp.gettextfile(file) do |line, newline|
                content.concat newline ? line + "\n" : line
              end # temporarly downloads the file
              FileUtils.rm file
              files[file] = { data: content }
            end
          end
        end
      end

      # Push this task's file content ftp server.
      # Existing contents by the same #file_name will be overriden.
      def push(task)
        client do |ftp|
          ftp.chdir(folder)
          ftp.put(task.file_path, task.file_name)
        end
      end

      # The raw url is for downloading the rake task content via ftp.
      # @param file_name [String] name of the file to retrieve the download url
      # @return [String] HTTP-URL of addressed file within the gist collection
      def raw_url(file_name)
        "ftp://#{user}@#{host}#{folder}#{file_name}"
      end

      protected

      def client
        Net::FTP.open(host, user, password) do |ftp|
          yield(ftp)
        end
      end
    end
  end
end
