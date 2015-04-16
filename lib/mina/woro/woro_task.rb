require 'net/https'

module Mina
  module Woro
    class Gister

      def initialize(task_name)

      end

      def file_name

      end

      def push(task_name)
        gist_id = gist_id_from_task_name(task_name)
        result = Gist.gist(task_file, public: false, update: gist_id, output: :all)
      end

      def retrieve_gist(gist_id)
        service_url = "https://api.github.com/gists/#{gist_id}"
        response = Net::HTTP.get_response(service_url)
        JSON.parse(response.body)
      end

      def retrieve_raw(service_url)
        response = Net::HTTP.get_response(service_url)
        response.body
      end

    end
  end
end
