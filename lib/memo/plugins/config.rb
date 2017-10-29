require 'memo/plugin'
require 'memo/config'

module Memo
  module Plugins
    class Config < Plugin
      desc 'config [OPERATION]', 'configure'

      option :cat do
        type    :boolean
        aliases '-c'
        default false
        desc    'print current config'
      end

      ldesc = <<-EOS
Editing config file by `config.editor'. Config file is YAML format.
Following config items are avaliable:

      EOS

      long_desc ldesc + Memo::Config.definitions.map{|k, d|
        "#{k}: #{d[:desc]}\n\n#{d[:long_desc]}"
      }.join("\n")

      def config
        if options[:cat]
          show_all_config
        else
          exec_editor app.class.config_path
        end
      end

      private

      def show_all_config
        $stderr.puts app.config.each_pair.map{|k, v| "#{k} = #{v.inspect}" }
      end
    end
  end
end
