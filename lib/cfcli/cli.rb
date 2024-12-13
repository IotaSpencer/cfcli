require "gli"
require "highline"
require "slugity/extend_string"
require "yaml"
require 'cloud_party'
require "terminal-table"
require "os"
require "rbconfig"
require "cfcli/version"
require 'cfcli/helpers'
require "pathname"

# for file in Pathname.new(File.dirname(__FILE__)).join("subs").children
#   require_relative file
# end

module CFCLI
  module App
    class MyGLI
      extend GLI::App
      program_desc "Interface with the Cloudflare API"
      program_long_desc <<-HEREDOC
      #{exe_name} is an interface into the Cloudflare API,
      usage is rate-limited by Cloudflare itself, not the gem.
  
      See https://api.cloudflare.com/#getting-started-requests for information
      on the API and the linked anchor for rate-limiting specifically.
      HEREDOC
      version CFCLI.version
      config_file ".cfcli/config"
      subcommand_option_handling :normal
      arguments :strict
      synopsis_format :compact
      wrap_help_text :verbatim

      flag "--format", arg_name: "FORMAT", desc: "output format", default_value: "table", must_match: /^([yY][aA][mM][lL]|[tT][aA][bB][lL][eE]|[pP][iI][pP][eE])$/
      desc 'manage zone related options/records'
      command "zones" do |zones_command|
        zones_command.desc "List all zones"
        zones_command.command :list do |c|
          c.action do |global_options, options, args|
            response = CloudParty::Nodes::Zones.new.list_zones
            results = response.results
            to_format global_options[:format], results

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
            puts table
          end
        end
        zones_command.default_command :list

        zones_command.desc "DNS Records management"
        zones_command.command "dns" do |dns_records|
          dns_records.desc "list record types"
          dns_records.command "list-record-types" do |types_command|
            types_command.action do |action|
              record_types = [
                "A",
                "AAAA",
                "CAA",
                "CERT",
                "CNAME",
                "DNSKEY",
                "DS",
                "HTTPS",
                "LOC",
                "MX",
                "NAPTR",
                "NS",
                "OPENPGPKEY",
                "PTR",
                "SMIMEA",
                "SRV",
                "SSHFP",
                "SVCB",
                "TLSA",
                "TXT",
                "URI",
              ]
              table_rows = []
              record_types.each_slice(7) do |chunk|
                table_rows << chunk
              end
              table = Terminal::Table.new do |t|
                t.rows = table_rows
                t.style = { :border_top => false, :border_bottom => false, :border_left => false, :border_right => false }
              end
              puts table
            end
          end
          dns_records.desc "list records"
          dns_records.command "list" do |list_command|
            list_command.flag 'zone', desc: "The zone to list records for",
                                      required: true
            list_command.action do |global_options, options, args|
              response = CloudParty::Nodes::DNSRecords.new.list(options[:zone])
            end
          end
          dns_records.desc 'add record'
          dns_records.command 'add' do |add_command|
            add_command.flag 'zone', desc: "The zone to add a record to",
                                    required: true,
                                    arg_name: 'ZONE_NAME'

            add_command.action do |global_options, options, args|
              response = CloudParty::Nodes::DNSRecords.new.add(options[:zone])
              puts response.result if response.methods.include(:result)
            end
          end
          dns_records.desc 'update record'
          dns_records.command 'update' do |update_command|
            update_command.flag 'zone', desc: "The zone to update a record in",
                                       required: true
          end
          dns_records.default_desc "help"
          dns_records.action do |global_options, options, args|
          end
        end
      end
      desc 'list ips'
      command 'ips' do |ips_command|
        ips_command.action do |action|
          response = CloudParty::Nodes::IPs.new.list()
          results = response.results.first
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

#       map %w[--debug -d] => :__debug
#       desc "--debug, -d", "Prints debug info about the script/gem"
#       # Prints debug info
#       # @return [NilClass] returns nil
#       def __debug
#         report = YAML.safe_load(OS.report)
#         rows = {
#           :cfcli_version => CFCLI::VERSION,
#           :ruby_version => RbConfig::CONFIG["RUBY_PROGRAM_VERSION"],
#         }
#         rows.merge! report
#         rows.merge!({
#           "ruby bin" => OS.ruby_bin,
#           :windows => OS.windows?,
#           :posix => OS.posix?,
#           :mac => OS.mac?,
#           "under windows" => OS::Underlying.windows?,
#           "under bsd" => OS::Underlying.bsd?,
#         })
#         table = Terminal::Table.new
#         table.title = "cfcli Debug Info"
#         table.rows = rows.to_a
#         table.align_column(0, :left)

#         puts table
#       end

#       map %w[--info -i] => :__print_info
#       desc "--info, -i", "Print script/gem info"
#       method_option :'info-format', :type => :string, desc: "The format of info", enum: %w(table yaml), default: "table"
#       # @return [NilClass] Prints Gem info
#       def __print_info
#         format = options[:'info-format']
#         rows = {
#           'author(s)': CFCLI::GemInfo.authors.join(", "),
#           'e-mail': CFCLI::GemInfo.email.join(", "),
#           'cfcli version': CFCLI::VERSION,
#           'Ruby version': RbConfig::CONFIG["RUBY_PROGRAM_VERSION"],
#           'Platform': RbConfig::CONFIG["build_os"],
#         }
#         case format
#         when "table"
#           table = Terminal::Table.new
#           table.style.alignment = :center
#           table.title = "CFCLI Info"
#           table.rows = rows.to_a
#           table.align_column(0, :left)

#           puts table
#         when "yaml"
#           puts rows.stringify_keys.to_yaml
#         else
#           # noop
#           # this doesn't get run because of
#           # the logic of options and their
#           # enum parameter.
#         end
#       end

#       desc "zones [SUBCOMMAND] ...ARGS [options]", "manage zone related options/records"
#       subcommand "zones", CFCLI::App::Subs::Zones
#     end
#   end
# end
