# frozen_string_literal: true

require "test_helper"

class TestRBZ < Minitest::Test
  ROOT = File.expand_path("..", __dir__)
  RUBY = RbConfig.ruby

  def test_that_it_has_a_version_number
    refute_nil ::RBZ::VERSION
  end

  def test_it_does_something_useful
    output = Dir.chdir(ROOT) do
      `#{RUBY} -Ilib exe/rbz example | #{RUBY} - ohai`
    end

    assert_equal "Hello world\n", output
  end
end
