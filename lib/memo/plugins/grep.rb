require 'memo/plugin'

module Memo
  module Plugins
    class Grep < Plugin
      desc 'grep PATTERN', 'grep memo'

      def grep(pattern)
        require 'shellwords'

        args = Shellwords.split(app.config.grep)
        args << pattern
        args.concat make_memo_list()
        Dir.chdir(memo_dir){ exec Shellwords.join(args) }
      end
    end
  end
end

