require 'spec_helper'

describe Woro::Task do

  subject { Woro::Task.new('cleanup_task') }

  describe '#create_from_task_template' do
    it 'creates new file' do
      FakeFS.deactivate!
      example_path = File.join('spec', 'fixtures','fresh_template.yml')
      fresh_template_body = File.read example_path
      FakeFS.activate!
      subject.create_from_task_template
      expect(File.read(Woro::Task.file_path)).to eq fresh_template_body
    end
  end

  describe '#file_name' do
    context 'taskname is cleanup_task' do
      it 'returns cleanup_task.rake' do
        expect(subject.file_name).to eq 'cleanup_task.rake'
      end
    end
  end

  describe '#file_path' do
    context 'task path is lib/woro_tasks/cleanup_task' do
      it 'returns lib/woro_tasks/cleanup_task.rake' do
        expect(subject.file_path).to eq 'lib/woro_tasks/cleanup_task.rake'
      end
    end
  end
end
