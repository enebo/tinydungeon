require 'tinydungeon/systems/commands/command'

class RmCommand < Command
  def execute(cmd)
    arg = rest(cmd)
    name, num, entity = name_to_object_info(cmd.entity, arg)
    name = arg unless name

    if entity
      entity.delete
      output_you cmd.entity, "Deleting #{name}"
    else
      output_you cmd.entity, "No such object named: #{name}"
    end
  end

  def description
    "Remove this object from the game"
  end

  def usage
    "/rm [{object}]"
  end

  def help
    super + <<EOS

{object} can be number, name, 'here', or 'me'.  If you omit
={description} then it just displays the current description.

Examples
/entity_examine me

EOS
  end
end
