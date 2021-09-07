# frozen_string_literal: true

require 'aws-sdk-s3'

module FetchAndProcess
  module S3
    def self.included(base)
      base.add_handler('s3', :s3_handler)
    end

    def s3_handler
      # TODO: Get the bucket and key from the URI
      options = {
        bucket: uri.host,
        key: uri.path[1..],
      }
      options[:if_modified_since] = File.mtime(cache_location) if File.exist?(cache_location)
      s3.get_object(options, target: cache_location)
    rescue Aws::S3::Errors::NotModified
      options.delete(:if_modified_since)
      s3.head_object(options)
    rescue Aws::S3::Errors::AccessDenied => e
      raise FetchAndProcess::AccessControlError, "Could not fetch file from S3: #{e.message}"
    rescue Aws::S3::Errors::NoSuchKey => e
      raise FetchAndProcess::FileNotFoundError, "Could not find file on S3: #{e.message}"
    end

    private

    def s3
      @s3 ||= Aws::S3::Client.new
    end
  end
end
