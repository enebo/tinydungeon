require 'tinydungeon/systems/commands/command'

class ExamineCommand < Command
  def execute(cmd)
    name = rest(cmd)
    name, num, entity = name_to_object_info(cmd.entity, name)
      
    if entity
        owner = Wreckem::Entity.find(entity.one(Owner))
        description = entity.one(Description)
        message = "#{name}(\##{num}) [#{owner.one(Name)}] - #{description}\n"
        output_you cmd.entity, message
    else
      output_you cmd.entity, "No such object named: #{name}"
    end
  end

  def description
    "Examine an item"
  end

  def usage
    "/examine [{object}]"
  end

  def help
    super + <<EOS

{object} can be number, name, 'here', or 'me'.  If you omit
={description} then it just displays the current description.

Examples
/examine me

EOS
  end
end
