require 'tinydungeon/systems/commands/command'

class DescribeCommand < Command
  def execute(cmd)
    rest = rest(cmd)
    unless rest
      output_you cmd.entity, "Must supply a name: #{usage}"
      return
    end

    name, description = rest.split(/\s*=\s*/, 2) 

    name, num, entity = name_to_object_info(cmd.entity, name)
      
    if entity
      if cmd.value !~ %r{=(.*)}
        entity.one(Description).update!('')
        output_you cmd.entity, "#{name}(\##{num}) description reset."
      else
        entity.one(Description).update!(description)
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
    "/describe [{object}][={description}]"
  end

  def help
    super + <<EOS

{object} can be number, name, 'here', or 'me'.  If you omit
={description} then it just displays the current description.

Examples
/describe me=Quite a fella
/describe me  # resets description

EOS
  end
end
