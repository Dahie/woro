require 'ostruct'
require 'woro'

# tasks available to mina to run remotely
namespace :woro do
  desc 'Run Woro task remotely'
  task run: :environment do
    config = Woro::Configuration.load
    task = Woro::Task.new(config.adapter[:gist][:gist_id], ENV['task'])
    print_status "Execute #{task.task_name} remotely"
    in_directory "#{app_path}" do
      queue! "cd 'lib/tasks' && curl -O #{task.raw_url}"
      queue! "#{bundle_prefix} rake woro:#{task.task_name}"
      queue! "rm lib/tasks/#{task.file_name}"
    end
  end
end
