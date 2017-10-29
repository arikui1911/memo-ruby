require 'memo/error'
require 'memo/util'
require 'shellwords'

module Memo
  class Plugin
    include Memo::Util

    Meta = Struct.new(:options, :name, :desc, :long_desc)

    class << self
      def meta
        @meta ||= Meta.new([])
      end

      alias class_name name

      def inherited(by)
        by.name by.class_name.sub('Memo::Plugins::', '').downcase.intern
      end

      def name(x)
        meta.name = x
        nil
      end

      def desc(*a)
        meta.desc = a
        nil
      end

      def option(*a, &block)
        if block_given?
          meta.options << OptionBuilder.new(*a, &block).result
        else
          meta.options << a
        end
        nil
      end

      class OptionBuilder
        def initialize(name, &block)
          @name = name
          @values_ = {}
          instance_eval(&block)
        end

        def result
          [@name, **@values_]
        end

        [:type, :aliases, :required, :default, :desc, :banner].each do |k|
          define_method(k){|v| @values_[k] = v }
        end
      end

      def long_desc(s)
        meta.long_desc = s
        nil
      end
    end

    def initialize(application)
      @application = application
      @options = nil
    end

    attr_reader :application
    alias app application
    attr_reader :options

    def bind_options(options)
      old = @options
      begin
        @options = options
        yield
      ensure
        @options = old
      end
    end

    private

    def memo_dir
      File.expand_path app.config.memo_dir
    end

    def make_memo_list
      make_memo_list_from memo_dir
    end

    def exec_editor(*files)
      exec Shellwords.join(Shellwords.split(app.config.editor).concat(files))
    end
  end
end

