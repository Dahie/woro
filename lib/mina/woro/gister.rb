require 'gist'

module Mina
  module Woro
    class Gister
      class << self
        def create_initial_gist(app_name)
          Gist.gist("Welcome to the Woro Task Repository for #{app_name}", filename: app_name)
        end
      end
    end
  end
end
