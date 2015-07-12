require 'commander'

module Woro
  # Set of helper methods used in the woro executable
  class TaskHelper
    include Commander::UI
    class << self
      # Check if woro environment is available in project
      def check_environment
        return if woro_environment_setup?
        abort 'Woro environment is not set up. Call `woro init` to do so.'
      end

      # Create the given directory, unless it already exists.
      # @param directory [String] directory to create
      def create_directory_unless_existing(directory)
        return if File.exist? directory
        FileUtils.mkdir_p directory
        say "Created `#{directory}`"
      end

      # Write a file at a given path with the given content, unless
      # it already exists.
      # @param file_path [String] save the new file here
      # @param content [String] write this into the file
      def create_file_unless_existing(file_path, content)
        return if File.exist? file_path
        File.open(file_path, 'w') do |f|
          f.puts content
        end
        say "Created `#{file_path}`"
      end

      # Creates all files required for a setup woro environment.
      def create_required_files
        create_directory_unless_existing Woro::Configuration.woro_task_dir
        create_file_unless_existing File.join(Woro::Configuration.woro_task_dir, '.gitignore'), '*.rake'
        create_directory_unless_existing Woro::Configuration.rake_task_dir
        create_directory_unless_existing File.dirname(Woro::Configuration.config_file)

        return if File.exist? File.join(Woro::Configuration.rake_task_dir, 'woro.rake')

        woro_task_file = File.join(File.dirname(__FILE__),
                                   'templates', 'woro.rake')
        FileUtils.cp(woro_task_file, Woro::Configuration.rake_task_dir)
        say "Created `woro.rake` in `#{Woro::Configuration.rake_task_dir}`"
      end

      # Returns true, if all requirements of a woro setup are met.
      # @return [boolean] all configurations, all directories exist
      def woro_environment_setup?
        File.exist?(Woro::Configuration.woro_task_dir) &&
          File.exist?(File.join('config', 'woro.yml')) &&
          File.exist?(Woro::Configuration.rake_task_dir) &&
          File.exist?(File.join(Woro::Configuration.rake_task_dir, 'woro.rake'))
      end

      # Display choice of adapter and return name of the chosen one.
      # @param choices [Array] list of choices
      # @return [String] Name of chosen adapter
      def select_choice(choices, message)
        choose do |menu|
          menu.prompt = message
          menu.choices(*choices) do |choice|
            return choice.to_s.strip
          end
        end
      end

      # Choose adapter and return its settings.
      # @param task_name [String] sanitized name of the task, used
      # @return [Hash] Hash with adapter name and its settings
      def choose_and_build_adapter_config(available_adapters)
        adapter_name = select_choice available_adapters, 'Please choose a service to use with Woro:'
        adapter = Object.const_get "Woro::Adapters::#{adapter_name}"
        { adapter_name.downcase => adapter.setup }
      end

      # Perform an action over all files within the woro task directory
      # @param directory [String] directory
      # @return [Array] List of rake tasks in the directory
      def woro_task_files(directory)
        tasks = []
        Dir.foreach(directory) do |file_name|
          if file_name.include? '.rake'
            data = File.read(File.join(directory, file_name))
            tasks << yield(file_name, data)
          end
        end
        tasks
      end

      # Read the rake task template
      # @return [String] Content of template file
      def read_template_file
        File.read File.join(File.dirname(__FILE__), 'templates', 'task.rake.erb')
      end
    end
  end
end
