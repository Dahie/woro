require 'ostruct'
require 'woro'

# Capistrano Recipes for managing woro tasks

Capistrano::Configuration.instance.load do
  namespace :woro do
    def rails_env
      fetch(:rails_env, false) ? "RAILS_ENV=#{fetch(:rails_env)}" : ''
    end

    desc 'Run Woro task remotely'
    task run: :environment do
      config = Woro::Configuration.load
      adapter_name, task_name,  = ENV['task'].split(':')
      adapter = config.adapter(adapter_name)
      task = Woro::Task.new(task_name)
      puts "Execute #{task.task_name} remotely"
      run "cd #{current_path}/lib/tasks && curl -O #{adapter.raw_url(task.file_name)}"
      run "cd #{current_path} && #{rails_env} rake woro:#{task.task_name}"
      run "cd #{current_path} && rm lib/tasks/#{task.file_name}"
    end
  end
end
