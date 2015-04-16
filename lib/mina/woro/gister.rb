require 'gist'

module Mina
  module Woro
    class Gister

      class << self

        def retrieve_from_task_name(task_name)
          gist = retrieve_gist gist_id_from_task_name(task_name)
          raw_url = gist['files'].first[1]['raw_url']
          retrieve_raw raw_url
        end

        def create_initial_gist(app_name)
          Gist.gist("Welcome to the Woro Task Repository for #{app_name}", filename: app_name)
        end

        def file_name_from_task_name(task_name)

        end

        def gist_id_from_task_name(task_name)
          full_file_name = file_name_from_task_name(task_name)
          match = /([a-f0-9]+)_(\d{14})_(\S+)/.match(full_file_name)
          gist_id = match[0]
        end

        private

        def gist_from_task_name(task_name)
          gist_id = gist_id_from_task_name(task_name)

        end


      end
    end
  end
end
