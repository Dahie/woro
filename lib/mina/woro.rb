require "woro/version"




def _tasks_dir
  fetch(:tasks_dir, 'lib/woro')
end

def _file_for_task(task_name)
  File.join(_tasks_dir, "#{task_name}.rb")
end

def _task_file_exists?(stage_name)
  File.exists?(File.expand_path(_file_for_task(task_name)))
end

def _get_all_tasks
  Dir["#{_tasks_dir}/*.rb"].reduce([]) { |tasks_stages, file| all_tasks << File.basename(file, '.rake') }
end

def prompt(*args)
  print(*args)
  gets
end

def _push_to_gist(file_name, options)

end

# tasks available to mina to run remotely
namespace :woro do
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
    end
  end

  desc 'Create new Woro task'
  task :new do
    # TODO create new woro task from given name

    # register

  end

  desc 'Push Woro task, updates existing'
  task :push do
    # Pushes a new woro task by given name to gist, this can be done multiple time.
    task_file = ENV['task']
    match = /([a-f0-9]+)_(\d{14})_(\S+)/.match(task_file)
    gist_id = match[0]
    result = Gist.gist(task_file, public: false, update: gist_id, output: :all)
  end

  desc 'Run Woro task'
  task :run do
    task_file = ENV['task']
    match = /([a-f0-9]+)_(\d{14})_(\S+)/.match(task_file)
    gist_id = match[0]
  end

  desc 'List all Woro tasks'
  task :list do
    # TODO
  end
end
