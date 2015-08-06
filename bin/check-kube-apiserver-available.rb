#! /usr/bin/env ruby

require 'sensu-plugin/check/cli'
require 'net/http'
require 'uri'

class ApiServerIsAvailable < Sensu::Plugin::Check::CLI
    option :api_server,
      description: 'URL to API server',
      short: '-s URL',
      long: '--api-server',
      default: ENV['KUBERNETES_MASTER']

    def run
      cli = ApiServerIsAvailable.new
      api_server = cli.config[:api_server]
      uri = URI.parse "#{api_server}/healthz"

      begin
        response = Net::HTTP.get_response(uri)
      rescue
        warning 'Host is unavailable'
      end

      if response.code.include? '200'
        ok 'Kubernetes API server is available'
      end
      critical 'Kubernetes API server is unavailable'
    end
end
