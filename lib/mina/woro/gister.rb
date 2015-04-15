require 'gist'
require 'net/https'

module Mina
  module Woro
    class Gister



      class << self

        def create_initial_gist
          app_name = Rails.application.name
          Gist.gist("Welcome to the Woro Task Repository for #{app_name}", filename: app_name)
        end

        def file_name_from_task_name(task_name)

        end

        def gist_id_from_task_name(task_name)
          full_file_name = file_name_from_task_name(task_name)
          match = /([a-f0-9]+)_(\d{14})_(\S+)/.match(full_file_name)
          gist_id = match[0]
        end

        def push_task(task_name)
          gist_id = gist_id_from_task_name(task_name)
          result = Gist.gist(task_file, public: false, update: gist_id, output: :all)
        end

        def gist_from_task_name(task_name)
          gist_id = gist_id_from_task_name(task_name)

        end

        def file_from_task_name(task_name)
          full_file_name = file_name_from_task_name(task_name)
          gist_id = gist_id_from_task_name(task_name)
          result = Gist.gist(task_file, public: false, update: gist_id, output: :all)
        end
      end
    end
  end
end
