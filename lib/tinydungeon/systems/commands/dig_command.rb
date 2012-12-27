require 'tinydungeon/systems/commands/command'

class DigCommand < Command
  def execute(cmd)
    name = rest(cmd)
    room = game.create_room(name, '')
    name, num, entity = name_to_object_info(cmd.entity, name)
    say_to_player cmd.entity, "Created a room named: #{name} (\##{num})"
  end

  def description
    "Dig (create) a new room"
  end

  def usage
    "@dig {name}"
  end

  def help
    super + <<EOS

{name} can be almost any string so long as it does not already exist
as a string in the system.

Examples
@dig Dark Grotto

See Also: @describe, @open
EOS
  end
end
