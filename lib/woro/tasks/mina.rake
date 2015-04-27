require 'ostruct'
require 'woro/gister'
require 'woro/task'

# tasks available to mina to run remotely
namespace :woro do
  desc 'Run Woro task remotely'
  task run: :environment do
    check_presence_of_task_name
    task = Woro::Task.new(fetch(:woro_token), Woro::Task.sanitized_task_name(ENV['task']))

    print_status "Execute #{Woro::Task.sanitized_task_name(ENV['task'])} remotely"
    in_directory "#{app_path}" do
      queue! "cd 'lib/tasks' && curl -O #{task.raw_url}"
      queue! "#{bundle_prefix} rake woro:#{Woro::Task.sanitized_task_name(ENV['task'])}"
      queue! "rm lib/tasks/#{task.file_name}"
    end
  end
end
