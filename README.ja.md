# memo

https://github.com/mattn/memo
の猿まねです。
Ruby での実装が欲しくて書きました。

## インストール

まだ gem にしてないです。

## 使い方

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

## プラグイン

memo のプラグインシステムはそんなに複雑ではない…はずです。

プラグインの名前は、a-zA-Z で始まり a-zA-Z0-9 で続く文字列、
つまりプログラミング言語の識別子みたいな文字列を、
ダッシュあるいはハイフンで連結したもの、になります。

そして、 memo/plugins/xxx というパスで require される
Ruby ライブラリが、 xxx という名前のプラグインを実装する
こととします。

さらに、そのプラグインを gem でインストールする場合、
memo-plugin-xxx という名前である必要があります。

プラグインの実装は Memo::Plugin クラスを継承したクラスに
対して行い、そのクラス名は Memo::Plugins::Xxx である
必要があります。 Xxx は、プラグイン名を、ダッシュあるいは
ハイフンを区切りとして分割し、キャピタライズし、連結し直した
名前になります。

 * 例: some-plug という memo プラグイン
 * gem: memo-plugin-some-plug
 * /lib/memo/plugins/some-plug.rb 内に
        require 'memo/plugin'

        module Memo
          module Plugins
            class SomePlug < Plugin
              # ...
            end
          end
        end

実例としては memo の標準コマンドはみんなプラグインで実装されて
いますので、 lib/memo/plugins/ 以下を見てみてください。


## ライセンス

LICENSE を見てください。 MIT ライセンスです。

## 連絡

arikui.ruby _at_ gmail.com

