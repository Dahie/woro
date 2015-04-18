require 'net/https'
require 'erb'

module Mina
  module Woro
    class Task
      attr_reader :task_name, :gist_id, :gist

      def initialize(gist_id, task_name)
        @task_name = task_name.strip.split(' ').first
        @gist_id = gist_id
      end

      def self.create(gist_id, task_name)
        task = Mina::Woro::Task.new(gist_id, task_name)
        task.create_empty_task
      end

      def file_name
        "#{task_name}.rake"
      end

      def file_path
        "lib/woro_tasks/#{file_name}"
      end

      def create_empty_task
        b = binding
        template = ERB.new(read_template_file).result(b)
        File.open(file_path, 'w') do |f|
          f.puts template
        end
      end

      def read_template_file
        File.read(file_path)
      end

      def read_task_file
        File.read(file_path)
      end

      def push
        Gist.multi_gist({ file_name => read_file_content },
                         public: false,
                         update: gist_id,
                         output: :all)
      end

      def gist
        @gist ||= retrieve_gist
      end

      def retrieve_file_data
        gist['files'][file_name]
      end

      def raw_url
        retrieve_file_data['raw_url']
      end

      def retrieve_raw_file
        response = Net::HTTP.get_response(raw_url)
        response.body
      end

      private

      def retrieve_gist
        service_url = "https://api.github.com/gists/#{gist_id}"
        response = Net::HTTP.get_response(URI.parse(service_url))
        JSON.parse(response.body)
      end
    end
  end
end
