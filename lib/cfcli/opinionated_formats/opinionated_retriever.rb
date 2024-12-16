require 'cfcli/helpers'

module CFCLI
  module OpinionatedFormats
    module Table
      module Endpoints
        require 'cfcli/opinionated_formats/table/zones'
        require 'cfcli/opinionated_formats/table/ips'
      end
    end
    module YML
      module Endpoints
        require 'cfcli/opinionated_formats/yaml/zones'
        require 'cfcli/opinionated_formats/yaml/ips'
      end
    end
    module Pipe
      module Endpoints
        #require 'cfcli/opinionated_formats/pipe/zones'
      end
    end
  
    class OpinionatedRetriever

      # Initializes a new instance of the OpinionatedRetriever class.
      #
      # @param format [String] the desired output format.
      # @param results [Object] the results to be processed.
      # @param endpoint [String] the endpoint URI.
      # @param options [Hash] additional options for configuration.
      def initialize(format, results, endpoint, **options)
        @options = options
        @endpoint = endpoint
        @results = results

      end
      # Outputs the results of the given endpoint in a table format.
      #
      # @param results [Object] the results to be processed.
      # @param endpoint [String] the endpoint URI.
      # @param kwargs [Hash] additional options for configuration.
      def self.output_endpoint_table(results, endpoint, **kwargs)
        inst = new('table', results, endpoint, **kwargs)
        endpoint_uri = inst.instance_variable_get(:@endpoint)
        endpoint_class = find_endpoint_class 'table', endpoint_uri
        puts endpoint_class.new(results: results).send
      end
      # Outputs the results of the given endpoint in a YAML format.
      #
      # @param results [Object] the results to be processed.
      # @param endpoint [String] the endpoint URI.
      # @param kwargs [Hash] additional options for configuration.
      def self.output_endpoint_yaml(results, endpoint, **kwargs)
        inst = new('yaml', results, endpoint, **kwargs)
        endpoint_uri = inst.instance_variable_get(:@endpoint)
        endpoint_class = find_endpoint_class 'yaml', endpoint_uri
        puts endpoint_class.new(results: results).send

      end
      # Outputs the results of the given endpoint in a pipe format.
      #
      # @param results [Object] the results to be processed.
      # @param endpoint [String] the endpoint URI.
      # @param kwargs [Hash] additional options for configuration.
      def self.output_endpoint_pipe(results, endpoint, **kwargs)
        inst = new('pipe', results, endpoint, **kwargs)
        endpoint_uri = inst.instance_variable_get(:@endpoint)
        endpoint_class = find_endpoint_class 'pipe', endpoint_uri
        puts endpoint_class.new(results: results).send

      end

      # Finds the endpoint class associated with the given endpoint URI.
      #
      # @param format [String] the desired output format.
      # @param endpoint_uri [String] the endpoint URI.
      #
      # @return [Class] the endpoint class.
      def self.find_endpoint_class(format, endpoint_uri)
        # endpoint_method = endpoint_uri.split(':').first
        endpoint_path = endpoint_uri.split('|').last
        class_ancestors = "CFCLI::OpinionatedFormats::"
        case format
        when "table"
          class_ancestors += "Table::"
        when "yaml"
          class_ancestors += "YML::"
        when "pipe"
          class_ancestors += "Pipe::"
        else
          raise "Unknown format: #{format}"
        end
        
        @endpoint_class = qualified_const_get(class_ancestors + "Endpoints::" + endpoint_path)
        puts @endpoint_class
        @endpoint_class
      end


    end
  end
end