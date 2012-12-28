require 'tinydungeon/systems/commands/command'

class DescribeCommand < Command
  def execute(cmd)
    name, description = rest(cmd).split(/\s*=\s*/, 2)
    name, num, entity = name_to_object_info(cmd.entity, name)
      
    if entity
      if cmd.value !~ %r{=(.*)}
        owner = manager[entity.one(Owner)]
        description = entity.one(Description)
        message = "#{name}(\##{num}) [#{owner.one(Name)}] - #{description}\n"
        output_you cmd.entity, message
      else
        entity.one(Description).value = description if entity
        output_you cmd.entity, "#{name}(\##{num}) changed to #{description}."
      end
    else
      output_you cmd.entity, "No such object named: #{name}"
    end
  end

  def description
    "See or set description of an object"
  end

  def usage
    "@describe [{object}][={description}]"
  end

  def help
    super + <<EOS

{object} can be number, name, 'here', or 'me'.  If you omit
={description} then it just displays the current description.

Examples
@describe me=Quite a fella
@describe me

EOS
  end
end
