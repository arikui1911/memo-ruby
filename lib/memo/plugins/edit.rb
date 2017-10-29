require 'memo/plugin'

module Memo
  module Plugins
    class Edit < Plugin
      desc 'edit [FILE]', 'edit memo'

      def edit(file = nil)
        if file
          exec_editor File.join(memo_dir, file)
        else
          selected = invoke_file_selector(make_memo_list()) or raise Interrupt
          exec_editor File.join(memo_dir, selected)
        end
      end

      private

      def invoke_file_selector(files)
        app.config.selector ? external_selector(app.config.selector, files) : default_selector(files)
      end

      def external_selector(prog, files)
        IO.popen(prog, 'r+'){|f|
          f.puts files
          f.close_write
          f.gets
        }.tap{|r| r and break(r.strip) }
      rescue Errno::ENOENT => e
        raise Error, "config.selector might be invalid: #{e.message}"
      end

      def default_selector(files)
        require 'readline'
        old = Readline.completion_proc
        begin
          Readline.completion_proc = ->(part){ files.select{|x| x.start_with?(part) } }
          input = Readline.readline('Edit ? > ', true) or return nil
          input.strip
        ensure
          Readline.completion_proc = old if old
        end
      end
    end
  end
end

