require 'memo/plugin'

module Memo
  module Plugins
    class New < Plugin
      desc 'new [TITLE]', 'create memo'

      def new(title = nil)
        raise Error, "config.memo_dir is required!" unless app.config.memo_dir

        require 'fileutils'

        title ||= ask_value('Title: ')
        path = File.join(memo_dir, "#{Time.now.strftime("%Y-%m-%d")}-#{escape_title(title)}.md")
        FileUtils.mkpath File.dirname(path)
        unless File.exist?(path)
          File.write path, "# #{title}\n\n"
        end
        exec_editor path
      end

      private

      def escape_title(title)
        title.tr(' <>:"/\\|?*%#]', '-').squeeze('-').sub(/\A[- ]+/, '').sub(/[- ]+\Z/, '')
      end
    end
  end
end

