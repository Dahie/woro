require 'mina/woro/gister'
require 'mina/woro/task'

def _tasks_dir
  #fetch(:tasks_dir, 'lib/woro_tasks')
  'lib/woro_tasks'
end

def prompt(*args)
  print(*args)
  STDIN.gets.chomp
end

# tasks available to mina to run remotely
namespace :woro do
  #set_default :access_token, '1234'
  #set_default :tasks_dir, 'lib/woro_tasks'
  #set_default :gist_token, -> {  }

  desc 'Initialize new Woro repository'
  task :init do
    FileUtils.mkdir_p _tasks_dir if !File.exists? _tasks_dir

    # use anonymous gist?
    login_gist = prompt "Login to Gist/Github for private Woro tasks (Yes/No):"
    if %w(yes y).include? login_gist
      Gist.login!
    else
      access_token = prompt "Secure gists via Access Token:"
    end

    # create Gist with welcome file
    # additional tasks will be added to this first gist
    app_name = fetch(:app_name, 'TestApp') #Rails.application.class.parent_name
    result = Mina::Woro::Gister.create_initial_gist(app_name)

    puts "add this to your deploy.rb:"
    puts "\n    set :woro_token, '#{result['id']}'\n"

    # safe in config
    #File.open('config/woro.rb', 'w') do |f|
    #  f.puts "set :woro_token, '#{result['id'].to_json}'"
    #end
  end

  desc 'Create new Woro task'
  task :new do
    # create new woro task from given name
    task_name = ENV['task']
    Mina::Woro::Task.create(fetch(:woro_token, '1d3332a5f4473879dcbc'), task_name)
  end

  desc 'Push Woro task, updates existing'
  task :push do
    # Pushes a new woro task by given name to gist, this can be done multiple time.
    task_name = ENV['task']
    task = Mina::Woro::Task.new(fetch(:woro_token), task_name)
    task.push
  end

  desc 'Run Woro task remotely'
  task :run => :environment do
    task_name = ENV['task']
    task = Mina::Woro::Task.new(fetch(:woro_token), task_name)

    in_directory "#{app_path}" do
      queue "cd 'lib/tasks' && curl -O #{task.raw_url}"
      queue "#{bundle_prefix} rake woro:#{task_name}"
      queue "rm lib/tasks/#{task.file_name}"
    end
  end

  desc 'List all remote Woro tasks'
  task :list do
    # TODO
  end
end
