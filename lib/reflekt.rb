require 'set'
require 'erb'
require 'rowdb'

################################################################################
# REFLEKT
#
# Usage. Prepend to the class like so:
#
#   class ExampleClass
#     prepend Reflekt
################################################################################

module Reflekt

  @@reflekt_clone_count = 5

  def initialize(*args)

    @reflekt_forked = false
    @reflekt_clones = []

    # Override methods.
    self.class.instance_methods(false).each do |method|
      self.define_singleton_method(method) do |*args|

        # When method called in flow.
        if @reflekt_forked
          unless self.class.deflekted?(method)

            # Reflekt on method.
            @reflekt_clones.each do |clone|
              reflekt_action(clone, method, *args)
            end

            # Save results.
            @@reflekt_db.write()

            # Render results.
            @@reflekt_json = File.read("#{@@reflekt_output_path}/db.json")
            template = File.read("#{@@reflekt_path}/template.html.erb")
            rendered = ERB.new(template).result(binding)

            # Write results.
            File.open("#{@@reflekt_output_path}/index.html", 'w+') do |f|
              f.write rendered
            end

          end
        end

        # Continue method flow.
        super *args
      end

    end

    # Continue contructor flow.
    super

    # Create forks.
    reflekt_fork()

  end

  def reflekt_fork()

    @@reflekt_clone_count.times do |clone|
      @reflekt_clones << self.clone
    end

    @reflekt_forked = true

  end

  def reflekt_action(clone, method, *args)

    class_name = clone.class.to_s
    method_name = method.to_s

    # Create new arguments.
    new_args = []
    args.each do |arg|
      case arg
      when Integer
        new_args << rand(9999)
      else
        new_args << arg
      end
    end

    # Action method with new arguments.
    begin
      clone.send(method, *new_args)

      # Build reflection.
      reflection = {
        "time" => Time.now.to_i,
      }
    # When error.
    rescue StandardError => error
      reflection["status"] = "error"
      reflection["error"] = error
    # When success.
    else
      reflection["status"] = "success"
    end

    # Save reflection.
    @@reflekt_db.get("#{class_name}.#{method_name}")
                .push(reflection)

  end

  private

  # Prepend Klass to the instance's singleton class.
  def self.prepended(base)
    base.singleton_class.prepend(Klass)

    @@reflekt_setup ||= reflekt_setup_klass
  end

  # Setup Klass.
  def self.reflekt_setup_klass()

    # Receive configuration from host application.
    $ENV ||= {}
    $ENV[:reflekt] ||= $ENV[:reflekt] = {}

    @@reflekt_path = File.dirname(File.realpath(__FILE__))

    # Create "reflections" directory in configured path.
    if $ENV[:reflekt][:output_path]
      @@reflekt_output_path = File.join($ENV[:reflekt][:output_path], 'reflections')
    # Create "reflections" directory in current execution path.
    else
      @@reflekt_output_path = File.join(Dir.pwd, 'reflections')
    end

    unless Dir.exist? @@reflekt_output_path
      Dir.mkdir(@@reflekt_output_path)
    end

    # Create database.
    @@reflekt_db = Rowdb.new(@@reflekt_output_path + '/db.json')
    @@reflekt_db.defaults({ :reflekt => { :api_version => 1 }}).write()

    return true
  end

  module Klass

    @@deflekted_methods = Set.new

    ##
    # Skip a method.
    #
    # method - A symbol representing the method name.
    ##
    def reflekt_skip(method)
      @@deflekted_methods.add(method)
    end

    def deflekted?(method)
      return true if @@deflekted_methods.include?(method)
      false
    end

  end

end
