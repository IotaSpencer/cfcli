require 'cfcli/opinionated_formats/opinionated_retriever'
require 'cfcli/qcg'
  # Outputs the results of the given endpoint in the desired format.
  #
  # @param format_option_value [String] the desired output format.
  # @param results [Object] the results to be processed.
  # @param endpoint [String] the endpoint URI.
  #
def to_format(format_option_value, results, endpoint: nil)
  case format_option_value
  when "table"
    CFCLI::OpinionatedFormats::OpinionatedRetriever.output_endpoint_table results, endpoint
  when "yaml"
    CFCLI::OpinionatedFormats::OpinionatedRetriever.output_endpoint_yaml results, endpoint
  when 'pipe'
    CFCLI::OpinionatedFormats::OpinionatedRetriever.output_endpoint_pipe results, endpoint
  else
    raise "Unknown format: #{format_option_value}"
  end
end



