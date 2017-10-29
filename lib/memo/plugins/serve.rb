require 'memo/plugin'

module Memo
  module Plugins
    class Serve < Plugin
      desc 'serve', 'start http server'

      option :address do
        aliases '-a'
        default '127.0.0.1'
        desc    'specify server address'
      end

      option :port do
        aliases '-p'
        default '8080'
        desc    'specify server listen port'
      end

      def serve
        require 'webrick'
        require 'kramdown'
        require 'memo/plugins/serve/template'

        server = WEBrick::HTTPServer.new(BindAddress: options[:address],
                                         Port:        options[:port])
        server.mount_proc('/'){|req, res|
          req_path = req.path.sub(/\A\//, '')
          if req_path.empty?
            serve_memo_list(req, res)
          else
            serve_memo_content(req_path, req, res)
          end
        }
        Signal.trap(:INT){ server.shutdown }
        th = Thread.start(server){|s| s.start }
        url = "http://#{options[:address]}:#{options[:port]}"
        system('xdg-open', url) or system('start', url)
        th.join
      end

      private

      def serve_memo_list(req, res)
        t = Template.new
        memos = make_memo_list().map{|file|
          [file, take_headline(File.join(memo_dir, file))]
        }
        res.body = t.memo_list(memo_dir, memos)
        res.content_type = 'text/html'
      end

      def serve_memo_content(path, req, res)
        doc = Kramdown::Document.new(File.read(File.join(memo_dir, path),
                                               encoding: 'utf-8'),
                                     input: 'GFM')
        t = Template.new
        res.body = t.memo_page(path, doc.to_html)
        res.content_type = 'text/html'
      end
    end
  end
end

