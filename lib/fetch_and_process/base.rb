# frozen_string_literal: true

require 'tmpdir'
require 'net/https'

module FetchAndProcess
  class Base
    attr_reader :file_path

    def initialize(file_path)
      @file_path = file_path
    end

    def uri
      @uri ||= URI.parse(file_path)
    end

    def process
      # No action defined by default
      raise FetchAndProcess::UnimplementedFileError
    end

    # After handle is executed, the fetched file should exist on the path specified by `target`
    def download
      raise FetchAndProcess::UnsupportedFileError unless uri.scheme && handle?

      send(handler)
    end

    def handle?
      self.class.handle?(uri)
    end

    def handler
      self.class.handler(uri)
    end

    def cache_location
      @cache_location ||= begin
        hash = Digest::MD5.hexdigest uri.to_s
        path = "#{Dir.tmpdir}/fetch_and_process"
        Dir.mkdir(path, 0o700) unless File.exist?(path)
        "#{path}/#{hash}"
      end
    end

    class << self
      def handle?(uri)
        handlers.key? uri.scheme.to_sym
      end

      def handler(uri)
        handlers[uri.scheme.to_sym]
      end

      def add_handler(scheme, method)
        handlers[scheme.to_sym] = method.to_sym
      end

      def handlers
        @handlers ||= {}
      end
    end
  end
end
