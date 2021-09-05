# frozen_string_literal: true

require 'tmpdir'
require 'net/https'

module FetchAndProcess
  module HTTP
    def self.included(base)
      base.add_handler('http', :http_handler)
      base.add_handler('https', :http_handler)
    end

    def user_agent
      "Ruby/FetchAndProcess-#{FetchAndProcess::VERSION} (Net::HTTP)"
    end

    def http_handler
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.port == 443) do |http|
        req = Net::HTTP::Get.new(uri)
        req['If-Modified-Since'] = File.mtime(cache_location).rfc2822 if File.exists?(cache_location)
        req['User-Agent'] = user_agent
        http.request(req) do |response|
          case response
          when Net::HTTPSuccess
            File.open(cache_location, 'w') do |file|
              response.read_body do |chunk|
                file.write(chunk)
              end
            end
          when Net::HTTPNotModified
            logger.debug 'Using cached file'
          else
            raise response.message
          end
        end
        cache_location
      end
    rescue StandardError => error
      # Ensure there's no empty / partial file to foul up the cache
      FileUtils.rm cache_location if File.exists?(cache_location)
      raise error
    end
  end
end
