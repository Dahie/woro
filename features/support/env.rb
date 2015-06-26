require "aruba/cucumber"
require 'cucumber/rspec/doubles'

Before do
  allow(Gist).to receive(:multi_gist).and_return({ 'id' => '1234'})
end

After do
  restore_env
end
