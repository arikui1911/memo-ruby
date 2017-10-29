require 'memo/plugin'

module Memo
  module Plugins
    class Delete < Plugin
      desc 'delete PATTERN', 'delete memo'

      option :regexp do
        type    :boolean
        aliases '-e'
        default false
        desc    'make pattern be interpreted as regular expression'
      end

      def delete(pattern)
        require 'fileutils'

        files = make_memo_list().
                select(&memo_pattern_matcher(pattern, options[:regexp]))
        if files.empty?
          $stderr.puts 'No matched entry'.
                        tap{|s| break colorize_yellow(s) if $stderr.tty? }
          return
        end
        $stderr.puts files
        $stderr.puts 'Will delete those entry. Are you sure?'.
                      tap{|s| break colorize_red(s) if $stderr.tty? }
        ask_yn('Are you sure?') or return
        ask_yn('Really?') or return
        FileUtils.rm files.map{|x| File.join(memo_dir, x) }
      end
    end
  end
end

