module Woro
  class TaskHelper
    class << self
      def print_task_list(tasks)
        width ||= tasks.map { |t| t.name_with_args.length }.max || 10
        tasks.each do |t|
          puts "  %-#{width}s   # %s" % [ t.name_with_args, t.comment ]
        end
      end

      # Perform an action over all files within the woro task directory
      def woro_task_files(directory, &block)
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
        task_content.match(/desc ['"]([a-zA-Z0-9\s]*)['"]/)[1]
      end

      # Read the rake task template
      # @return [String]
      def read_template_file
        File.read(File.join(File.dirname(__FILE__), 'templates','task.rake.erb') )
      end
    end
  end
end
