require 'woro/version'
require 'woro/task_helper'
require 'woro/task'
require 'woro/task_list'
require 'woro/adapters/base'
require 'woro/adapters/ftp'
require 'woro/configuration'

# require any gem with the prefix "woro" found in the gemset
[].tap do |woro_specs|
  Gem::Specification::each do |spec|
    woro_specs << spec.name if spec.name.start_with?('woro') && spec.name != 'woro'
  end
  woro_specs.uniq.each { |spec| require spec }
end
