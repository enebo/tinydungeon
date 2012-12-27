require 'tinydungeon/systems/commands/command'

class DescribeCommand < Command
  def execute(cmd)
    name, description = rest(cmd).split(/\s*=\s*/, 2)
    name, num, entity = name_to_object_info(cmd.entity, name)
      
    if entity
      if cmd.value !~ %r{=(.*)}
        say_to_player cmd.entity, "#{name.value}(\##{num}) = #{entity.one(Description).value}"
      else
        entity.one(Description).value = description if entity
        say_to_player cmd.entity, "#{name.value}(\##{num}) changed to #{description}."
      end
    else
      say_to_player cmd.entity, "No such object named: #{name}"
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
