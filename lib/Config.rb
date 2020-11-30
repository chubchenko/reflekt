class Config

  attr_accessor :reflect_amount
  attr_accessor :reflect_limit
  attr_accessor :meta_map
  attr_accessor :output_path
  attr_accessor :output_directory

  def initialize()

    # The amount of reflections to create per method call.
    @reflect_amount = 2

    # The maximum amount of reflections that can be created per instance/method.
    # A method called thousands of times doesn't need that many reflections.
    @reflect_limit = 10

    # The rules that apply to meta types.
    @meta_map = {
      :array  => [ArrayRule],
      :bool   => [BooleanRule],
      :int    => [IntegerRule],
      :string => [StringRule]
    }

    # An absolute path to the directory that contains the output directory.
    # Defaults to current execution path.
    @output_path = nil

    # Name of output directory.
    @output_directory = "reflections"

  end

end
