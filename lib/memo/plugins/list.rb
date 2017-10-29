require 'memo/plugin'

module Memo
  module Plugins
    class List < Plugin
      desc 'list [PATTERN]', 'list memo'

      option :regexp do
        type    :boolean
        aliases '-e'
        default false
        desc    'make pattern be interpreted as regular expression'
      end

      option :fullpath do
        type    :boolean
        aliases '-f'
        default false
        desc    'show file by full path'
      end

      option :headline do
        type    :boolean
        aliases '-H'
        desc    'show headline of file too'
      end

      option :truncate do
        type    :boolean
        aliases '-t'
        desc    'truncate output regard to console size'
      end

      def list(pattern = nil)
        raise Error, "config.memo_dir is required!" unless app.config.memo_dir

        require 'io/console/size'
        require 'unicode/display_width'

        fullpath_p, headline_p, truncate_p =
                                options.values_at(:fullpath, :headline, :truncate)
        headline_p = !fullpath_p if headline_p.nil?
        truncate_p = !fullpath_p if truncate_p.nil?

        col = app.config.column.to_i
        col = 30 unless col > 0

        output =
          case
          when headline_p && truncate_p && $stdout.tty?
            ->(path, show_path){
              "#{colorize_green truncate(show_path, col)} : #{colorize_yellow truncate(take_headline(path), console_width - 4 - col)}"
            }
          when headline_p && truncate_p
            ->(path, show_path){
              "#{truncate(show_path, col)} : #{truncate(take_headline(path), console_width - 4 - col)}"
            }
          when truncate_p
            ->(path, show_path){ truncate(show_path, console_width) }
          when headline_p
            ->(path, show_path){ "#{show_path} : #{take_headline path}" }
          else
            ->(path, show_path){ show_path }
          end

        make_memo_list().
          select(&memo_pattern_matcher(pattern, options[:regexp])).each{|x|
          path = File.join(memo_dir, x)
          show_path = fullpath_p ? path : x
          puts output.(path, show_path)
        }
      end

      private

      def console_width
        IO.console_size[1]
      end

      def truncate(str, len, omission = '...')
        widths = Hash.new{|h, k| h[k] = Unicode::DisplayWidth.of(k) }
        n = 0
        over_len_p = false
        str.each_char do |c|
          if (n += widths[c]) > len
            over_len_p = true
            break
          end
        end
        return str.dup unless over_len_p
        lim = len - widths[omission]
        n = 0
        chars = str.each_char.take_while{|c| (n += widths[c]) <= lim }
        chars.join << omission
      end
    end
  end
end

