require 'spec_helper'
require 'json'

describe Woro::Adapters::Gist do

  let!(:gist_id) { rand(999)}
  let(:task) { Woro::Task.new('create_user') }
  subject { Woro::Adapters::Gist.new(gist_id) }
  let(:gist_hash) do
    FakeFS.deactivate!
    body = File.read(File.join('spec', 'fixtures', 'gist.json'))
    FakeFS.activate!
    JSON.parse(body)
  end

  before do
    allow(subject).to receive(:gist).once.and_return gist_hash
  end

  describe '#list_keys' do
    it 'returns list' do
      expected_list = {
        "create_user.rake" => {
          "size"=>932, "raw_url"=>"https://gist.githubusercontent.com/raw/365370/8c4d2d43d178df44f4c03a7f2ac0ff512853564e/ring.erl", "type"=>"text/plain", "language"=>"Ruby", "truncated"=>false, "content"=>"namespace :woro do\n  desc 'Create User'\n  task create_user: :environment do\n    # Code\n  end\nend\n"
        }
      }
      expect(subject.list_keys).to eq expected_list
    end
  end

  describe '#push' do
    it 'calls gist services with correct params' do
      File.open(task.file_path, 'w') do |f|
        f.puts 'hey'
      end
      expected_files_hash = { task.file_name => task.read_task_file }
      expected_params_hash = { public: false,
                               update: gist_id,
                               output: :all
                              }
      expect(Gist).to receive(:multi_gist).with(expected_files_hash, expected_params_hash).and_return gist_hash
      subject.push(task)
    end
  end


  describe '#retrieve_file_data' do
    it 'returns data hash from file' do
      expected_hash = {
        "size"=>932, "raw_url"=>"https://gist.githubusercontent.com/raw/365370/8c4d2d43d178df44f4c03a7f2ac0ff512853564e/ring.erl", "type"=>"text/plain", "language"=>"Ruby", "truncated"=>false, "content"=>"namespace :woro do\n  desc 'Create User'\n  task create_user: :environment do\n    # Code\n  end\nend\n"
      }
      expect(subject.retrieve_file_data('create_user.rake')).to eq expected_hash
    end
  end

  describe '#raw_url' do
    it 'returns raw_url of file' do
      expected_url = "https://gist.githubusercontent.com/raw/365370/8c4d2d43d178df44f4c03a7f2ac0ff512853564e/ring.erl"
      expect(subject.raw_url('create_user.rake')).to eq expected_url
    end
  end
end
