require 'thor'

module Memo
  class CLI < Thor
    class << self
      attr_accessor :application

      def load_plugin_class(c)
        desc(*c.meta.desc)
        c.meta.options.each{|x| option(*x) }
        long_desc(c.meta.long_desc) if c.meta.long_desc
        cli = self
        define_method(c.meta.name){|*args|
          cxt = c.new(cli.application)
          cxt.bind_options(options) do
            cli.application.invoke cxt, *args
          end
        }
      end
    end
  end
end

