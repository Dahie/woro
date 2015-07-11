require 'net/https'
require 'erb'

module Woro
  # Task object, helps in the creation and management of gists.
  class Task
    attr_reader :task_name, :gist

    def initialize(task_name)
      @task_name = Woro::Task.sanitize_task_name task_name
    end

    # Create new Task, creates vanilla task file in the woro
    # task directory.
    # @param task_name [String] sanitized name of the task, used
    # throughout the further processing
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
    # @return [String] taskname with extension
    def file_name
      "#{task_name}.rake"
    end

    # File name based on the task's filename (see #file_name).
    # @return [String] taskname with extension and relative path
    def file_path
      File.join 'lib', 'woro_tasks', file_name
    end

    # Returns true, if a task of this name exists locally
    # @return [boolean] task file exists locally
    def exists?
      File.exist? file_path
    end

    # Read template and inject new name
    # @return [String] source code for new task
    def build_task_template
      b = binding
      ERB.new(Woro::TaskHelper.read_template_file).result(b)
    end

    # Creates a new rake task file at the file path (see #file_path).
    def create_from_task_template
      File.open(file_path, 'w') do |f|
        f.puts build_task_template
      end
    end

    # Read the content of the local rake task file on #file_path.
    # @return [String] file content
    def read_task_file
      File.read(file_path)
    end
  end
end
