class StringRule < Rule

  attr_accessor :min_length
  attr_accessor :max_length

  def initialize()
    @min_length = nil
    @max_length = nil
  end

  def load(value)
    @values << value
  end

  def train()
    # TODO.
  end

  def validate()
    # TODO.
    true
  end

end
