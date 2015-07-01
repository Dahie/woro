require 'yaml'
require 'commander'
include Commander::UI

module Woro
  class Configuration
    attr_reader :adapter_settings, :woro_task_dir, :app_name

    # Initialize configuration.
    def initialize(options = {})
      @woro_task_dir = Configuration.woro_task_dir
      @adapter_settings = options['adapters'] || {}
      @app_name = options['app_name']
    end

    # Load configuration file or default_options. Passed options take precedence.
    def self.load(options = {})
      user_options = options.reject { |k, v| !['adapters', 'app_name'].include? k }

      unless File.exist? config_file
        File.open(config_file, 'w') { |file| YAML.dump(default_options, file) }
        say "Initialized default config file in `#{config_file}`. See 'woro help init' for options."
      end

      config_file_options = YAML.load_file(config_file)
      new(config_file_options.merge(user_options))
    end

    # Save configuration. Passed options take precendence over default_options.
    def self.save(options = {})
      user_options = options.reject { |k, v| !['adapters', 'app_name'].include? k }
      force_save = options.delete :force

      if !File.exist?(config_file) || force_save
        File.open(config_file, 'w') do |file|
          YAML.dump(default_options.merge(user_options), file)
        end
        say "Initialized config file in `#{config_file}`"
      else
        say_error "Not overwriting existing config file `#{config_file}`, use --force to override. See 'woro help init'."
      end
      self
    end

    def adapter(adapter_name)
      clazz = Object.const_get("Woro::Adapters::#{adapter_name.capitalize}")
      clazz.new adapter_settings[adapter_name.downcase]
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
