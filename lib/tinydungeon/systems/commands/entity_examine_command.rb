require 'tinydungeon/systems/commands/command'

class EntityExamineCommand < Command
  def execute(cmd)
    name, description = rest(cmd).split(/\s*=\s*/, 2)
    name, num, entity = name_to_object_info(cmd.entity, name)
      
    if entity
      output_you cmd.entity, manager.entity_as_string(entity)
    else
      output_you cmd.entity, "No such object named: #{name}"
    end
  end

  def description
    "See underlying entity values for object"
  end

  def usage
    "@entity_examine [{object}]"
  end

  def help
    super + <<EOS

{object} can be number, name, 'here', or 'me'.  If you omit
={description} then it just displays the current description.

Examples
@entity_examine me

EOS
  end
end
