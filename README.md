# memo

copycat of https://github.com/mattn/memo
I wanted a implementation by Ruby.

## Installation

I don't make a gem yet.

## Usage

```
$ memo help
Commands:
  memo config [OPERATION]  # configure
  memo delete PATTERN      # delete memo
  memo edit [FILE]         # edit memo
  memo grep PATTERN        # grep memo
  memo help [COMMAND]      # Describe available commands or one specific command
  memo list [PATTERN]      # list memo
  memo new [TITLE]         # create memo
  memo serve               # start http server
```

## Plugin

A memo plugin system is not so complicated, I think.

<dl>
    <dt>plugin name</dt>
    <dd>more than 1 [a-zA-Z][a-zA-Z0-9]*, joined by '-' or '_' (e.g. plug-name)
    <dt>plugin require path</dt>
    <dd>memo/plugins/plug-name</dd>
    <dt>plugin gem name</dt>
    <dd>memo-plugin-plug-name</dd>
    <dt>plugin class name</dt>
    <dd>Memo::Plugins::PlugName
</dl>
 
/lib/memo/plugins/plug-name.rb:
```ruby
require 'memo/plugin'

module Memo
  module Plugins
    class PlugName < Plugin
      # ...
    end
  end
end
```

See lib/memo/plugins/* for example. memo commands are implemented as a plugin.

## License

See LICENSE (MIT License).

## Contact

arikui.ruby _at_ gmail.com
