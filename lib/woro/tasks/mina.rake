require 'ostruct'
require 'woro/gister'
require 'woro/task'

def extract_description(data)
  data['content'].match(/desc ['"]([a-zA-Z0-9\s]*)['"]/)[1]
end

# tasks available to mina to run remotely
namespace :woro do

  desc 'Push and run Woro task remotely'
  task execute: environment do
    invoke :'woro:push'
    invoke :'woro:run'
  end

  desc 'Push Woro task to remote repository, updates existing'
  task :push do
    check_presence_of_task_name

  end

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

  desc 'List all remote Woro tasks'
  task :list do
    files = Woro::Gister.get_list_of_files(fetch(:woro_token))
    tasks = files.map { |file_name, data| OpenStruct.new(name_with_args: file_name.split('.rake').first, comment: extract_description(data)) if file_name.include? '.rake' }
    tasks.compact!
    width ||= tasks.map { |t| t.name_with_args.length }.max || 10
    tasks.each do |t|
      puts "  #{name} %-#{width}s   # %s" % [ t.name_with_args, t.comment ]
    end
  end
end
