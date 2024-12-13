module CFCLI

  VERSION = [0,0,1]
  VERSION_PRE = ''
  module_function

  # Returns the version of the CFCLI gem in a useful format.
  # 
  # @param [Symbol] how what format to return the version in.
  #   +:string+ returns a string with the version number.
  #   +:array+ returns an array with the version number.
  #   +nil+ returns a string with the version number.
  #
  # @return [String or Array] the version of the gem.
  def version(how = nil)
    ver = VERSION
    if VERSION_PRE != ''
      # If there is a pre-release version, append it to the version
      ver += '.' + VERSION_PRE
    end
    # Return the version in the requested format
    if how == :string || how == nil
      ver.join('.')
    end
  end
end