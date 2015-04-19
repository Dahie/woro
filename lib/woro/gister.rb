require 'gist'
require 'net/https'

module Woro
  class Gister
    class << self
      def create_initial_gist(app_name)
        Gist.gist("Welcome to the Woro Task Repository for #{app_name}", filename: app_name)
      end

      def retrieve_gist(gist_id)
        service_url = "https://api.github.com/gists/#{gist_id}"
        response = Net::HTTP.get_response(URI.parse(service_url))
        JSON.parse(response.body)
      end

      def get_list_of_files(gist_id)
        retrieve_gist(gist_id)['files']
      end
    end
  end
end
