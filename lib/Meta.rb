################################################################################
# Meta for input and output. All meta behave the same.
#
# @pattern Abstract class.
# @see lib/meta for each meta.
################################################################################

class Meta

  ##
  # Each meta loads values.
  #
  # @param value [Dynamic]
  ##
  def load(value)
  end

  ##
  # Each meta provides metadata.
  #
  # @return [Hash]
  ##
  def result()
    {}
  end

end
