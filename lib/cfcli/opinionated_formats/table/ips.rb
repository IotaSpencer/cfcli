require 'cfcli/helpers'
module CFCLI
  module OpinionatedFormats
    module Table
      module Endpoints
        class IPs
          def initialize(**options)
            @options = options
          end
          def send
            results = @options[:results]
            ipv4_results = results.ipv4_cidrs
            ipv6_results = results.ipv6_cidrs
            table = Terminal::Table.new do |t|
              t.headings = ["CIDR", "IP/prefix"]
              t.add_row ["IPv4", ipv4_results.join("\n")]
              t.add_separator
              t.add_row ["IPv6", ipv6_results.join("\n")]
            end
            puts table
          end
        end
      end
    end
  end
end