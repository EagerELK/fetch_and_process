# frozen_string_literal: true

require_relative 'fetch_and_process/version'
require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect 'http' => 'HTTP'
loader.setup

module FetchAndProcess
  class Error < StandardError; end

  class UnsupportedFileError < Error; end

  class UnimplementedFileError < Error; end

  class AccessControlError < Error; end

  class FileNotFoundError < Error; end
end
