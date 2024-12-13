def to_format(format_option_value, results, endpoint: nil, **kwargs)
  case format
  when "table"
    output_endpoint_table results, endpoint, **kwargs
  when "yaml"

  when 'pipe'

  else
    raise "Unknown format: #{format}"
  end
end



