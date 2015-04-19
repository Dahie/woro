require 'net/https'
require 'erb'

module Woro
  class Task
    attr_reader :task_name, :gist_id, :gist

    def initialize(gist_id, task_name)
      @task_name = task_name
      @gist_id = gist_id
    end

    def self.create(gist_id, task_name)
      task = Woro::Task.new(gist_id, task_name)
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
      File.read(File.dirname(__FILE__) +"/templates/task.rake")
    end

    def read_task_file
      File.read(file_path)
    end

    def push
      Gist.multi_gist({ file_name => read_task_file },
                       public: false,
                       update: gist_id,
                       output: :all)
    end

    def gist
      @gist ||= Gister.retrieve_gist(gist_id)
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
  end
end
