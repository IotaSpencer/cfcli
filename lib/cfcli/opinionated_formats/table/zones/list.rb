module CFCLI
  module OpinionatedFormats
    module Table
      module Endpoints
        class Zones
          class List
            def initialize(**options)
              @options = options
            end
            def send
              results = @options[:results]
              table = ::Terminal::Table.new do |t|
                t.headings = ["Name", "ID", "Status", "Paused", "Type"]
                t.rows = results.map do |zone|
                  [
                    zone.name,
                    zone.id,
                    zone.status,
                    zone.paused,
                    zone.type,
                  ]
                end
              end
              return table
            end
          end
        end
      end
    end
  end
end