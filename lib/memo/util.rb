autoload :Readline, 'readline'

module Memo
  module Util
    module_function

    def make_memo_list_from(dir)
      Dir.entries(dir).
        reject{|x| x.start_with?('.') }.
        select{|x| File.extname(x).downcase == '.md' }
    end

    def memo_pattern_matcher(pattern, regexp = false)
      case
      when !pattern
        ->(_){ true }
      when regexp
        Regexp.compile(pattern).method(:match)
      else
        ->(s){ s.include? pattern }
      end
    end

    def take_headline(path)
      File.open(path){|f| take_headline_io f }
    end

    def take_headline_io(f)
      buf = []
      get_line = ->(){ buf.empty? ? f.gets : buf.pop }
      first = line = get_line.() or return ''
      # skip front matter section (--- ... ---)
      if first.chomp == '---'
        while line = get_line.()
          break if line.chomp == '---'
        end
        return first.chomp unless line
      else
        buf.push first
      end
      # skip empty lines
      while line = get_line.()
        break unless line.strip.empty?
      end
      line ? line.chomp.sub(/\A#*\s*/, '') : ''
    end

    def ask_value(prompt)
      input = Readline.readline(prompt, true) and input.strip
    end

    def ask_yn(question)
      v = ask_value("#{question} (y/N): ") and v.start_with?('y', 'Y')
    end

    def ask_yes_no(question)
      v = ask_value("#{question} (yes/No): ") and
        v.strip.slice(/\A\w+/).downcase == 'yes'
    end

    def colorize_red(str)
      colorize str, 31
    end

    def colorize_green(str)
      colorize str, 32
    end

    def colorize_yellow(str)
      colorize str, 33
    end

    def colorize(str, color_code)
      "\e[#{color_code}m#{str}\e[0m"
    end
  end
end
