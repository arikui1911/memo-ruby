module Memo
  module Plugins
    class << self
      def load
        listup().each do |name|
          require "memo/plugins/#{name}"
          klass_name = name.split(/[-_]/).map(&:capitalize).join
          klass = const_get(klass_name)
          yield klass if block_given?
          store[name] = klass
        end
      end

      def listup
        (listup_load_path_plugins() + listup_gem_plugins()).uniq
      end

      def [](key)
        store[key]
      end

      private

      def store
        @store ||= {}
      end

      PLUGIN_NAME_RE = /\A[a-zA-Z]\w*(?:[-_][a-zA-Z]\w*)*\Z/

      PLUGIN_GEM_PREFIX = 'memo-plugin-'

      def gem_list
        Gem.refresh
        Gem::Specification
      end

      def listup_gem_plugins
        gem_list().lazy.select{|gem|
          gem.name.downcase.start_with?(PLUGIN_GEM_PREFIX)
        }.map{|gem|
          gem.name[PLUGIN_GEM_PREFIX.length..-1]
        }.select{|name|
          PLUGIN_NAME_RE =~ name
        }.to_a
      end

      def load_path
        $LOAD_PATH
      end

      def listup_load_path_plugins
        load_path().lazy.flat_map{|dir|
          Dir.glob(File.join(dir, 'memo/plugins/*.rb'))
        }.map{|path|
          File.basename(path, '.rb')
        }.select{|name|
          PLUGIN_NAME_RE =~ name
        }.to_a
      end
    end
  end
end
