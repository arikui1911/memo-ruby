gem 'test-unit'
require 'test/unit'
require 'tmpdir'
require 'fileutils'
require 'stringio'
require 'memo/util'

class TestUtil < Test::Unit::TestCase
  test '#make_memo_list' do
    Dir.mktmpdir do |dir|
      files = ['hoge.md',
               'piyo.md',
               '.dot.md',
               'fuga.rb']
      FileUtils.touch files.map{|x| File.join(dir, x) }
      assert_equal(['hoge.md',
                    'piyo.md'],
                   Memo::Util.make_memo_list_from(dir))
    end
  end

  sub_test_case '#memo_pattern_matcher' do
    test 'always matches' do
      m = Memo::Util.memo_pattern_matcher(nil)
      assert m[Object.new]
      assert m[666]
      assert m['hoge']
    end

    test 'regexp matcher' do
      m = Memo::Util.memo_pattern_matcher('^.a.', true)
      assert !m['foo']
      assert  m['bar']
      assert  m['baz']
    end

    test 'partial matcher' do
      m = Memo::Util.memo_pattern_matcher('Ru')
      assert  m['Ruby']
      assert !m['Perl']
      assert  m['Rust']
      assert  m['JRuby']
    end
  end

  sub_test_case '#take_headline_io' do
    test 'first head line with front matter' do
      f = StringIO.new(<<-EOS)
---
foo: 999
bar: 123
baz: 666
---

# headline
      EOS
      assert_equal 'headline', Memo::Util.take_headline_io(f)
    end

    test 'first text line with front matter' do
      f = StringIO.new(<<-EOS)
---
foo: 999
bar: 123
baz: 666
---

headline

      EOS
      assert_equal 'headline', Memo::Util.take_headline_io(f)
    end

    test 'first text line' do
      f = StringIO.new(<<-EOS)

headline

      EOS
      assert_equal 'headline', Memo::Util.take_headline_io(f)
    end
  end

  test '#colorize_red' do
    assert_equal "\e[31mRED\e[0m", Memo::Util.colorize_red('RED')
  end

  test '#colorize_green' do
    assert_equal "\e[32mGREEN\e[0m", Memo::Util.colorize_green('GREEN')
  end

  test '#colorize_yellow' do
    assert_equal "\e[33mYELLOW\e[0m", Memo::Util.colorize_yellow('YELLOW')
  end
end

