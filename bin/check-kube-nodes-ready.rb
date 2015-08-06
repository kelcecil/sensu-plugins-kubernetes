#! /usr/bin/env ruby

require 'sensu-plugin/check/cli'
require 'json'
require 'kubeclient'

class AllNodesAreReady < Sensu::Plugin::Check::CLI
    option :api_server,
      description: 'URL to API server',
      short: '-s URL',
      long: '--api-server',
      default: ENV['KUBERNETES_MASTER']

    option :api_version,
      description: 'API version',
      short: '-v VERSION',
      long: '--api-version',
      defualt: 'v1'

    def run
      cli = AllNodesAreReady.new
      api_server = cli.config[:api_server]
      api_version = cli.config[:api_version]

      begin
        client = Kubeclient::Client.new(api_server, api_version)
      rescue
        warning 'Unable to connect to Kubernetes API server'
      end

      failed_nodes = Array.new
      client.get_nodes.each do |node|
        lambda do
          node.status.conditions.each do |condition|
            next if condition.type != 'Ready'
            if condition.status != 'True'
              failed_nodes << node.metadata.name
            end
            return  # Return from the lambda
          end
          warning "#{node.name} does not have a status"
        end.call
      end

      if failed_nodes.size == 0
        ok 'All nodes are reporting as ready'
      end
      critical "Nodes are not ready: #{failed_nodes.join(' ')}"
    end
end
