# frozen_string_literal: true

require 'tmpdir'
require 'net/https'

module FetchAndProcess
  module LocalFile
    def self.included(base)
      base.add_handler('file', :file_handler)
    end

    def file_handler
      from = uri.to_s.sub(/^file:\/\//, '')
      from = "./#{from}" if from[0] != '/'
      FileUtils.cp from, cache_location
      cache_location
    end
  end
end
