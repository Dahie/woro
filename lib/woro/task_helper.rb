module Woro
  class TaskHelper

    class << self

      # Read the rake task template
      # @return [String]
      def read_template_file
        File.read(File.join(File.dirname(__FILE__), 'templates','task.rake') )
      end
    end
  end
end
