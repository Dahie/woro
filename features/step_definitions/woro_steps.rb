require 'woro'

Given /^the following tasks:$/ do |table|
  data = table.raw
  table.raw.each do |task|
    steps %Q{
      When I run `pomo add '#{task.first}'`
    }
  end
end

Given /^the Woro environment is set up$/ do
  create_dir Woro::Configuration.woro_task_dir
  create_dir Woro::Configuration.rake_task_dir

  write_file(File.join(Woro::Configuration.rake_task_dir, 'woro.rake'),
             File.read(File.dirname(__FILE__) + '/../../lib/woro/templates/woro.rake') )
  write_file(File.join('config', 'woro.yml'),
             { adapters: {} }.to_yaml)


end
