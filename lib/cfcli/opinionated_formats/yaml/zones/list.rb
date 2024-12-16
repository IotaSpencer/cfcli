module CFCLI
  module OpinionatedFormats
    module YML
      module Endpoints
        class Zones
          class List
            def initialize(**options)
              @options = options
            end
            def send
              results = @options[:results]
              yml = <<~YAMLDOC
              zones:
            YAMLDOC
            results.each do |zone|
              yml += <<~YML.gsub(/^(?:|\w)/, "  ")
                - name: #{zone.name}
                  id: #{zone.id}
                  status: #{zone.status}
                  paused: #{zone.paused}
                  type: #{zone.type}
              YML
            end

              return yml
            end
          end
        end
      end
    end
  end
end