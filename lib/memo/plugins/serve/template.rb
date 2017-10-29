require 'erb'

module Memo
  module Plugins
    class Serve
      class Template
        include ERB::Util

        def memo_list(title, memos)
          common_html(title){ memos_html(memos) }
        end

        def memo_page(title, body)
          common_html(title){ body }
        end

        ERB.new(<<-EOS, nil, '%-').def_method(self, 'memos_html(memos)', __FILE__)
    <dl>
      <%- memos.each do |file, headline| -%>
      <dt><a href="/<%= u file %>"><%= h file %></a></dt>
      <dd><%= h headline %></dd>
      <%- end -%>
    </dl>
    EOS
        private :memos_html

        ERB.new(<<-EOS, nil, '%-').def_method(self, 'common_html(title)', __FILE__)
<!DOCTYPE html>
<html lang="ja">
  <head>
    <meta charset="utf-8">
    <title><%= h title %></title>
  </head>
  <body>
<%= yield %>
  </body>
</html>
    EOS
        private :common_html
      end
    end
  end
end
