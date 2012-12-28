require 'tinydungeon/systems/commands/command'

class TellCommand < Command
  def execute(cmd)
    rest = rest(cmd)
    unless rest
      output_you cmd.entity, "Must supply a name: #{usage}"
      return
    end

    name, message = rest.split(/\s*=\s*/, 2) 

    name, num, entity = name_to_object_info(cmd.entity, name)

    say entity, message
  end

  def description
    "say something to someone"
  end

  def usage
    "tell {object}={message}"
  end
end
