require 'ostruct'
require 'mina/woro/gister'
require 'mina/woro/task'

def prompt(*args)
  print(*args)
  STDIN.gets.chomp
end

def sanitized_task_name
  ENV['task'].strip.split(' ').first
end

def check_presence_of_task_name
  if ENV['task'].nil?
    print_error('No taskname given.')
    raise 'No taskname given'
  end
end

def extract_description(data)
  data['content'].match(/desc ['"]([a-zA-Z0-9\s]*)['"]/)[1]
end

# tasks available to mina to run remotely
namespace :woro do

  desc 'Initialize new Woro repository'
  task :init do
    FileUtils.mkdir_p _tasks_dir if !File.exists? _tasks_dir

    print status 'Configure Gist/Github access'

    login_gist = prompt "Login to Gist/Github for private Woro tasks (Yes/No):"
    if %w(yes y).include? login_gist
      Gist.login!
    #else
    #  access_token = prompt "Secure gists via Access Token:"
    end

    # create Gist with welcome file
    # additional tasks will be added to this first gist
    app_name = fetch(:app_name, 'TestApp') #Rails.application.class.parent_name
    result = Mina::Woro::Gister.create_initial_gist(app_name)


    print status 'Setup in your project'
    print_stdout "add this to your deploy.rb:"
    print_stdout "set :woro_token, '#{result['id']}"

    print status 'Create woro.rake in lib/tasks/'
    FileUtils.cp(File.dirname(__FILE__) +"/templates/woro.rake", 'lib/tasks/')
    print status 'Create woro_tasks in lib/'
    FileUtils.mkdir('lib/woro_tasks')
  end

  desc 'Create new Woro task'
  task :new do
    check_presence_of_task_name
    Mina::Woro::Task.create(fetch(:woro_token), sanitized_task_name)
  end

  desc 'Push and run Woro task remotely'
  task execute: environment do
    invoke :'woro:push'
    invoke :'woro:run'
  end

  desc 'Push Woro task, updates existing'
  task :push do
    check_presence_of_task_name
    # Pushes a new woro task by given name to gist, this can be done multiple time.
    task = Mina::Woro::Task.new(fetch(:woro_token), sanitized_task_name)
    task.push
  end

  desc 'Run Woro task remotely'
  task run: :environment do
    check_presence_of_task_name
    task = Mina::Woro::Task.new(fetch(:woro_token), sanitized_task_name)

    print_status "Execute #{sanitized_task_name} remotely"
    in_directory "#{app_path}" do
      queue! "cd 'lib/tasks' && curl -O #{task.raw_url}"
      queue! "#{bundle_prefix} rake woro:#{sanitized_task_name}"
      queue! "rm lib/tasks/#{task.file_name}"
    end
  end

  desc 'List all remote Woro tasks'
  task :list do
    files = Mina::Woro::Gister.get_list_of_files(fetch(:woro_token))
    tasks = files.map { |file_name, data| OpenStruct.new(name_with_args: file_name.split('.rake').first, comment: extract_description(data)) if file_name.include? '.rake' }
    tasks.compact!
    width ||= tasks.map { |t| t.name_with_args.length }.max || 10
    tasks.each do |t|
      puts "  #{name} %-#{width}s   # %s" % [ t.name_with_args, t.comment ]
    end
  end
end
