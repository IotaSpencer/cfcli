require 'yaml'
module CFCLI
  module OpinionatedFormats
    module YML
      module Endpoints
        class IPs
          def initialize(**options)
            @options = options
          end
          def send
            results = @options[:results]
            
            ips = {}
            ips['ips'] = {}
            ips['ips']['ipv4'] = results.ipv4_cidrs
            ips['ips']['ipv6'] = results.ipv6_cidrs
            YAML.dump(ips)
            
          end
        end
      end
    end
  end
end