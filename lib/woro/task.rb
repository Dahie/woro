require 'net/https'
require 'erb'

module Woro
  # Task object, helps in the creation and management of gists.
  class Task
    attr_reader :task_name, :gist

    def initialize(task_name)
      @task_name = Woro::Task.sanitize_task_name task_name
    end

    # @param task_name [String] sanitized name of the task, used throughout the further processing
    # @return [Task] the created task
    def self.create(task_name)
      task = Woro::Task.new(task_name)
      task.create_from_task_template
      task
    end

    def self.sanitize_task_name(task_name)
      task_name.strip.split(' ').first # not nice
    end

    # File name based on the task's name.
    # @return [String]
    def file_name
      "#{task_name}.rake"
    end

    # File name based on the task's filename (see #file_name).
    # @return [String]
    def file_path
      File.join 'lib', 'woro_tasks', file_name
    end

    # Returns true if a task of this name exists locally
    def exists?
      File.exist? file_path
    end

    # Creates a new rake task file at the file path (see #file_path).
    def create_from_task_template
      b = binding
      template = ERB.new(Woro::TaskHelper.read_template_file).result(b)
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
  end
end
