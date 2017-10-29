require 'memo/error'
require 'memo/config'
require 'memo/plugins'
require 'rubygems'

module Memo
  class Application
    CONFIG_PATH = '~/.config/memo/config.yaml'

    def self.config_path
      @config_path ||= File.expand_path(CONFIG_PATH)
    end

    def initialize(ui)
      @config = nil
      @ui = ui
      ui.application = self
    end

    attr_reader :config

    def run(argv)
      load_config
      load_plugins
      @ui.start argv
    rescue Memo::Error => e
      $stderr.puts "ERROR: #{e.message}"
      exit false
    rescue Interrupt
      exit false
    end

    def invoke(plugin, *args)
      name = plugin.class.meta.name
      g = plugin.method(name).parameters.group_by(&:first)
      required = g[:req] ? g[:req].size : 0
      optional = g[:opt] ? g[:opt].size : 0
      rest     = g[:rest]
      case
      when args.size < required
        basename = File.basename($PROGRAM_NAME).split(" ").first
        raise Thor::InvocationError, <<-EOS
ERROR: #{basename} #{name}: invalid arguments
Usage: #{basename} #{plugin.class.meta.desc.first}
        EOS
      when rest
        plugin.send(name, *args)
      else
        plugin.send(name, *args[0, required], *args[required, optional])
      end
    end

    private

    def load_config
      @config = begin
                  Config.load(self.class.config_path)
                rescue Config::LoadError
                  Config.new.tap{|c| c.save self.class.config_path }
                end
    end

    def load_plugins
      Plugins.load{|klass| @ui.load_plugin_class klass }
    end
  end
end
