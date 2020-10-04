################################################################################
# ACCESSOR
#
# Access variables via one object to avoid polluting the caller class.
#
# Only 2 variables are not accessed via Accessor:
#   - @reflection_counts on the instance
#   - @@reflekt_skipped_methods on the instance's singleton class
################################################################################

class Accessor

  attr_accessor :setup
  attr_accessor :db
  attr_accessor :json
  attr_accessor :stack
  attr_accessor :rules
  attr_accessor :path
  attr_accessor :output_path
  attr_accessor :reflect_amount
  attr_accessor :reflection_limit

  def initialize()

    @setup = nil
    @db = nil
    @json = nil
    @stack = nil
    @rules = nil
    @path = nil
    @output_path = nil
    @reflect_amount = nil
    @reflection_limit = nil

  end

end
