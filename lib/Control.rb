################################################################################
# A shapshot of real data.
#
# @note
#   A control's @number property will always be zero.
#
# @nomenclature
#   args, inputs/output and meta represent different stages of a value.
#
# @hierachy
#   1. Action
#   2. Control <- YOU ARE HERE
#   3. Meta
#
# @status
#   - :pass [Symbol] The reflection passes the rules.
#   - :fail [Symbol] The reflection fails the rules or produces a system error.
#   - :error [Symbol] The control reflection produces a system error.
################################################################################

require 'Reflection'
require 'MetaBuilder'

class Control < Reflection

  ##
  # Reflect on a method.
  #
  # Creates a shadow execution.
  # @param *args [Dynamic] The method's arguments.
  ##
  def reflect(*args)

    # Get trained rule sets.
    input_rule_sets = @aggregator.get_input_rule_sets(@klass, @method)
    output_rule_set = @aggregator.get_output_rule_set(@klass, @method)

    ## When no trained rule sets consider this a new control.
    #if input_rule_sets.nil?
    #  @status = :fail
    #end

    # When arguments exist.
    unless args.size == 0

      # When trained rule sets exist.
      unless input_rule_sets.nil?

        # Validate arguments against trained rule sets.
        unless @aggregator.test_inputs(args, input_rule_sets)
          @status = :fail
        end

      end

      # Create metadata for each argument.
      # TODO: Create metadata for other inputs such as instance variables.
      @inputs = MetaBuilder.create_many(args)

    end

    # Action method with new/old arguments.
    begin

      # Run reflection.
      output = @clone.send(@method, *args)
      @output = MetaBuilder.create(output)

      # Validate output with aggregated control rule sets.
      unless output_rule_set.nil?
        unless @aggregator.test_output(output, output_rule_set)
          @status = :fail
        end
      end

    # When a system error occurs.
    rescue StandardError => message

      @status = :error
      @message = message

    end

  end

end
