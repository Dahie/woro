require 'spec_helper'

describe Woro::Configuration do

  describe '#initialize' do
    it 'instantiates object' do
      options = {
        adapters: %(foo baz),
        app_name: 'bar'
      }
      config = Woro::Configuration.new(options)
      expect(config.adapters).to eq %(foo baz)
      expect(config.app_name).to eq 'bar'
    end
  end

  describe '.load' do
    context 'not given a configuration file' do
      it 'returns Configuration object with default options' do
        config = Woro::Configuration.load
        expect(config.adapters).to be_falsy
        expect(config.app_name).to be_falsy
      end

      it 'writes a configuration file with default options' do
        Woro::Configuration.load
        expect(File.read(Woro::Configuration.config_file)).to eq \
          YAML.dump(Woro::Configuration.default_options)
      end
    end

    context 'given a configuration file' do
      before(:each) do
        opts = {
          adapters: %w(foo baz),
          app_name: 'bar'
        }
        File.open(Woro::Configuration.config_file, 'w') do |file|
          YAML.dump(opts, file)
        end
      end

      it 'returns Configuration object with options in file' do
        config = Woro::Configuration.load
        expect(config.adapters).to eq %w(foo baz)
        expect(config.app_name).to eq 'bar'
      end

      context 'given options' do
        it 'overrides options in configuration file' do
          options = {
            adapters:  %w(goo grr),
            app_name: 'car'
          }
          config = Woro::Configuration.load(options)
          expect(config.adapters).to eq %w(goo grr)
          expect(config.app_name).to eq 'car'
        end
      end
    end
  end

  describe '.save' do
    let(:options) do
      {
        adapters: ['foo', 'baz'],
        app_name: 'bar'
      }
    end

    context 'not given a configuration file' do
      it 'writes a configuration file with options' do
        Woro::Configuration.save(options)
        expect(File.read(Woro::Configuration.config_file)).to eq \
          YAML.dump(options)
      end
    end

    context 'given a configuration file' do
      before(:each) do
        opts = {
          adapters: ['goo', 'grr'],
          app_name: 'car'
        }
        File.open(Woro::Configuration.config_file, 'w') do |file|
          YAML.dump(opts, file)
        end
      end

      it 'does not overwrite' do
        Woro::Configuration.save(options)
        expect(File.read(Woro::Configuration.config_file)).to_not eq \
          YAML.dump(options)
      end

      it 'does overwrite if passed `force` option' do
        Woro::Configuration.save(options.merge(:force => true))
        expect(File.read(Woro::Configuration.config_file)).to eq \
          YAML.dump(options)
      end
    end
  end
end
