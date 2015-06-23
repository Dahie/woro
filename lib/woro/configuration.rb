require 'yaml'
require 'commander'
include Commander::UI

module Woro
  class Configuration
    attr_reader :adapters, :woro_task_dir, :app_name

    # Initialize configuration.
    def initialize(options = {})
      @woro_task_dir = Configuration.woro_task_dir
      @adapters = options[:adapters] || {}
      @app_name = options[:app_name]
    end

    # Load configuration file or default_options. Passed options take precedence.
    def self.load(options = {})
      user_options = options.reject{|k,v| ![:adapters, :app_name].include? k}

      if !(File.exists? config_file)
        File.open(config_file, 'w') { |file| YAML.dump(default_options, file) }
        say "Initialized default config file in #{config_file}. See 'woro help init' for options."
      end

      config_file_options = YAML.load_file(config_file)
      new(config_file_options.merge(user_options))
    end

    # Save configuration. Passed options take precendence over default_options.
    def self.save(options = {})
      user_options = options.reject{|k,v| ![:adapters, :app_name].include? k}
      force_save = options.delete :force

      if !(File.exists? config_file) || force_save
        File.open(config_file, 'w') do |file|
          YAML.dump(default_options.merge(user_options), file)
        end
        say "Initialized config file in #{config_file}"
      else
        say_error "Not overwriting existing config file #{config_file}, use --force to override. See 'woro help init'."
      end
      self
    end

    def adapter(name)
      options = adapters[name.to_sym]

      case name.to_sym
      when :gist
        @gist_adapter ||= Woro::Adapters::Gist.new(options[:gist_id])
      end
    end

    # Helpers

    def self.config_file
      File.join('config', 'woro.yml')
    end

    def self.woro_task_dir
      File.join('lib', 'woro_tasks')
    end

    def self.rake_task_dir
      File.join('lib', 'tasks')
    end

    def self.default_options
      {
      }
    end
  end
end
