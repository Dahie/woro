require 'commander'

module Woro
  class TaskHelper
    include Commander::UI
    class << self
      def create_directory_unless_existing(directory)
        unless File.exist? directory
          FileUtils.mkdir_p directory
          say "Created `#{directory}`"
        end
      end

      def create_file_unless_existing(file_path, content)
        unless File.exist? file_path
          File.open(file_path, 'w') do |f|
            f.puts content
          end
          say "Created `#{file_path}`"
        end
      end

      def create_required_files
        create_directory_unless_existing Woro::Configuration.woro_task_dir
        create_file_unless_existing File.join(Woro::Configuration.woro_task_dir, '.gitignore'), '*.rake'
        create_directory_unless_existing Woro::Configuration.rake_task_dir
        create_directory_unless_existing File.dirname(Woro::Configuration.config_file)

        unless File.exist? File.join(Woro::Configuration.rake_task_dir,
                           'woro.rake')
          woro_task_file = File.join(File.dirname(__FILE__),
                                     'templates', 'woro.rake')
          FileUtils.cp(woro_task_file, Woro::Configuration.rake_task_dir)
          say "Created `woro.rake` in `#{Woro::Configuration.rake_task_dir}`"
        end
      end

      def woro_environment_setup?
        File.exist?(Woro::Configuration.woro_task_dir) &&
          File.exist?(File.join('config', 'woro.yml')) &&
          File.exist?(Woro::Configuration.rake_task_dir) &&
          File.exist?(File.join(Woro::Configuration.rake_task_dir, 'woro.rake'))
      end

      def select_choice(choices)
        choose do |menu|
          menu.prompt = 'Please choose a service to use with Woro:'
          menu.choices(*choices) do |choice|
            return choice.to_s.strip
          end
        end
      end

      def choose_and_build_adapter_config(available_adapters)
        adapter_name = select_choice available_adapters
        adapter = Object.const_get "Woro::Adapters::#{adapter_name}"
        { adapter_name.downcase => adapter.setup }
      end

      def print_task_list(tasks)
        width ||= tasks.map { |t| t.name_with_args.length }.max || 10
        tasks.each do |t|
          say "  %-#{width}s   # %s" % [ t.name_with_args, t.comment ]
        end
      end

      # Perform an action over all files within the woro task directory
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

      # Extract description from gist's data content string.
      # @param data [Hash] gist data hash
      # [String] description string
      def extract_description(task_content)
        # regex from http://stackoverflow.com/questions/171480/regex-grabbing-values-between-quotation-marks
        match = task_content.match(/desc (["'])((?:(?!\1)[^\\]|(?:\\\\)*\\[^\\])*)\1/)
        match && match[2] || 'No description'
      end

      # Read the rake task template
      # @return [String]
      def read_template_file
        File.read(File.join(File.dirname(__FILE__), 'templates','task.rake.erb') )
      end
    end
  end
end
