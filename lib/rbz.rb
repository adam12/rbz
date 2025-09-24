# frozen_string_literal: true

require "pathname"
require_relative "rbz/version"
require_relative "rbz/cli"

module RBZ
  def self.templates
    Pathname(__dir__).join("rbz/templates")
  end
end
