require 'mina/woro/gister'

def _tasks_dir
  #fetch(:tasks_dir, 'lib/woro_tasks')
  'lib/woro_tasks'
end

def _file_for_task(task_name)
  File.join(_tasks_dir, "#{task_name}.rb")
end

def _task_file_exists?(task_name)
  File.exists?(File.expand_path(_file_for_task(task_name)))
end

def _get_all_tasks
  Dir["#{_tasks_dir}/*.rb"].reduce([]) { |tasks_stages, file| all_tasks << File.basename(file, '.rake') }
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

    # if external git

    #repo = Rugged::Repository.new(_tasks_dir)
    # enter git path
    #git_path = 'TODO'
    # check git connection


    # if gist

    # use anonymous gist?
    login_gist = prompt "Login to Gist/Github for private Woro tasks (Yes/No):"
    if %w(yes y).include? login_gist
      Gist.login!
    else
      access_token = prompt "Secure gists via Access Token:"
    end

    # create Gist with welcome file
    # additional tasks will be added to this first gist
    #app_name = Rails.application.class.parent_name
    result = Mina::Woro::Gister.create_initial_gist('TestApp')

    puts "add this to your deploy.rb:"
    puts "set :woro_token, '#{result['id'].to_json}'"

    # safe in config

    #File.open('config/woro.rb', 'w') do |f|
    #  f.puts "set :woro_token, '#{result['id'].to_json}'"
    #end
  end

  desc 'Create new Woro task'
  task :new do
    # TODO create new woro task from given name
    Gister.create_(app_name)

    # register

  end

  desc 'Push Woro task, updates existing'
  task :push do
    # Pushes a new woro task by given name to gist, this can be done multiple time.
    task_name = ENV['task']
    Gister.push_task(task_name)
  end

  desc 'Run Woro task remotely'
  task :run do
    task_name = ENV['task']

    Gister.retrieve_from_task_name(task_name)

    # take raw and execute as mina task
    file_name

    queue "cd 'lib/tasks' && curl -O https://gist.github.com/#{gist_id}/raw/#{file_name}"
    # create rake task
    queue "bundle exec rake woro:#{task_name}"
    # invoke rake task
    queue "rm lib/tasks/#{file_name}"
    #delete #rake task

  end

  desc 'List all remote Woro tasks'
  task :list do
    # TODO
  end
end
