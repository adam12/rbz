# frozen_string_literal: true

require "pathname"
require_relative "rbz/version"

module Rbz
  def self.templates
    Pathname(__dir__).join("rbz/templates")
  end
end
