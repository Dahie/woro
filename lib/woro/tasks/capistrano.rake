require 'woro'

# Capistrano recipees for managing woro tasks
namespace :woro do
  desc 'Run Woro task remotely'
  task run: 'deploy:set_rails_env' do

    on roles(:app), in: :sequence, wait: 5 do
      unless ENV['task'].include?(':')
        error "Does not specify upload target"
      else
        config = Woro::Configuration.load

        adapter_name, task_name = ENV['task'].split(':')
        adapter = config.adapter(adapter_name)
        task = Woro::Task.new(task_name)

        info "Execute #{task.task_name} remotely"
        within File.join(release_path, 'lib', 'tasks') do
          execute :curl, '-sS', "'#{adapter.raw_url(task.file_name)}'",  '-o', "woro_#{task.file_name}"
        end
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, "woro:#{task.task_name}"
            execute :rm, "lib/tasks/woro_#{task.file_name}"
          end
        end
      end
    end
  end
end
