require 'ostruct'
require 'woro'

# tasks available to mina to run remotely
namespace :woro do
  desc 'Run Woro task remotely'
  task run: :environment do
    config = Woro::Configuration.load
    unless ENV['task'].include?(':')
      print_error "Does not specify upload target"
      return
    end
    adapter_name, task_name = ENV['task'].split(':')
    adapter = config.adapter(adapter_name)
    task = Woro::Task.new(task_name)
    print_status "Execute #{task.task_name} remotely"
    in_directory "#{app_path}" do
      queue! "curl -sS '#{adapter.raw_url(task.file_name)}' -o lib/tasks/woro_#{task.file_name}"
      queue! "#{bundle_prefix} rake woro:#{task.task_name}"
      queue! "rm lib/tasks/woro_#{task.file_name}"
    end
  end
end
