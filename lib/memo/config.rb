require 'memo/error'
require 'yaml'

module Memo
  CONFIG_DEFINITIONS = {
    memo_dir: {
      desc: 'directory which put on memo files',
    },
    editor: {
      desc: 'editor program (for editing memo and config)',
      default: 'vim',
    },
    column: {
      default: 30,
    },
    selector: {
      desc: 'file selector program (e.g. peco)',
      long_desc: <<-EOS
'file selector' means a program which reads stdin lines as selection
and put a line selected by user to stdout.

When `config.selector' is unset, default selector will be used. It is
independent of other external programs.
      EOS
    },
    grep: {
      desc: 'GREP program',
      default: 'grep',
    },
    assets_dir: {
    },
  }

  Config = Struct.new(*CONFIG_DEFINITIONS.keys) do
    def self.load(path)
      c = new()
      begin
        data = File.open(path){|f|
          f.flock File::LOCK_SH
          YAML.load f
        }
      rescue Errno::ENOENT => e
        raise LoadError, e.message
      end
      h = Hash.try_convert(data) and h.each{|k, v| c[k] = v }
      c
    end

    def self.definitions
      CONFIG_DEFINITIONS
    end

    def initialize
      super()
      self.class.definitions.each{|k, d| self[k] = d[:default] }
    end

    def save(dest)
      data = members.map{|k| [k.id2name, self[k]] }.to_h
      begin
        File.open(dest, 'r+'){|f|
          f.flock File::LOCK_EX
          f.rewind
          YAML.dump data, f
          f.truncate f.tell
        }
      rescue Errno::ENOENT
        File.open(dest, 'w'){|f|
          f.flock File::LOCK_EX
          YAML.dump data, f
        }
      end
    end
  end

  class Config::LoadError < Error ; end
end
