require 'ostruct'
require 'commander'
include Commander::UI

module Woro
  # Generates the list of all tasks for printout to console.
  class TaskList
    attr_reader :config, :list

    def initialize(config)
      @config = config
      @list = []
    end

    # Determine the max count of characters for all task names.
    # @return [integer] count of characters
    def width
      @width ||= list.map { |t| t.name_with_args ? t.name_with_args.length : 0 }.max || 10
    end

    # Fill task list by loading tasks from the configured adapters and locally.
    # @return [Object] task_list
    def fill
      fill_list_from_adapters
      fill_list_from_local
      self
    end

    # Print the current task list to console.
    def print
      list.each do |entry|
        entry.headline ? print_headline(entry) : print_task_description(entry)
      end
    end

    # Extract description from gist's data content string.
    # @param data [Hash] gist data hash
    # [String] description string
    def self.extract_description(task_content)
      # regex from http://stackoverflow.com/questions/171480/regex-grabbing-values-between-quotation-marks
      match = task_content.match(/desc (["'])((?:(?!\1)[^\\]|(?:\\\\)*\\[^\\])*)\1/)
      match && match[2] || 'No description'
    end

    protected

    def fill_list_from_local
      list << OpenStruct.new(headline: 'local')
      Woro::TaskHelper.woro_task_files(config.woro_task_dir) do |file_name, data|
        list << OpenStruct.new(name_with_args: file_name.split('.rake').first,
                       comment: Woro::TaskList.extract_description(data))
      end
    end

    def fill_list_from_adapters
      adapter_settings.each do |adapter_setting|
        list << OpenStruct.new(headline: adapter_setting[0])
        adapter = config.adapter(adapter_setting[0])
        files = adapter.list_contents || {}
        files.map do |file_name, data|
          if file_name.include? '.rake'
            list << OpenStruct.new(name_with_args: file_name.split('.rake').first,
                           comment: adapter.extract_description(data[:data]))
          end
        end
        list.compact!
      end
    end

    def adapter_settings
      config.adapter_settings
    end

    def print_headline(headline)
      say "#{headline.headline} ---"
    end

    def print_task_description(task)
      say "  %-#{width}s   # %s" % [task.name_with_args, task.comment]
    end
  end
end
