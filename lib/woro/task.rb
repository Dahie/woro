require 'net/https'
require 'erb'

module Woro
  # Task object, helps in the creation and management of gists.
  class Task
    attr_reader :task_name, :gist_id, :gist

    def initialize(gist_id, task_name)
      @task_name = task_name
      @gist_id = gist_id
    end

    # Create a new task based on a template rake-task.
    # @param gist_id [String] gist to which the task is added
    # @param task_name [String] sanitized name of the task, used throughout the further processing
    # @return [Task] the created task
    def self.create(gist_id, task_name)
      task = Woro::Task.new(gist_id, task_name)
      task.create_from_task_template
      task
    end

    # File name based on the task's name.
    # @return [String]
    def file_name
      "#{task_name}.rake"
    end

    # File name based on the task's filename (see #file_name).
    # @return [String]
    def file_path
      "lib/woro_tasks/#{file_name}"
    end

    # Creates a new rake task file at the file path (see #file_path).
    def create_from_task_template
      b = binding
      template = ERB.new(Gister.read_template_file).result(b)
      File.open(file_path, 'w') do |f|
        f.puts template
      end
    end

    # Requests the content of the task file within the Gist collection
    # from the server.
    # @return [String]
    def retrieve_raw_file
      response = Net::HTTP.get_response(raw_url)
      response.body
    end

    # Read the content of the local rake task file on #file_path.
    def read_task_file
      File.read(file_path)
    end

    # Push this task's file content to the Gist collection on the server.
    # Existing contents by the same #file_name will be overriden, but
    # can be accessed via Github or Gist's API.
    def push
      Gist.multi_gist({ file_name => read_task_file },
                       public: false,
                       update: gist_id,
                       output: :all)
    end

    # The Gist contains a collection of files.
    # These are stored and accessed on Github.
    # @return [Hash] parsed JSON hash of the gist's metadata
    def gist
      @gist ||= Gister.retrieve_gist(gist_id)
    end

    # Retrieves the data hash included in the gist under the #file_name.
    # @return [Hash] parsed JSON hash
    def retrieve_file_data
      gist['files'][file_name]
    end

    # The raw url is a permalink for downloading the content rake task within
    # the Gist as a file.
    def raw_url
      retrieve_file_data['raw_url']
    end
  end
end
