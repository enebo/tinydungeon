require 'tinydungeon/systems/commands/command'

class DigCommand < Command
  def execute(cmd)
    name = rest(cmd)
    room = game.create_room(name, '', cmd.entity)
    output_you cmd.entity, "Created a room named: #{name} (\##{room.id})"
  end

  def description
    "Dig (create) a new room"
  end

  def usage
    "/dig {name}"
  end

  def help
    super + <<EOS

{name} can be almost any string so long as it does not already exist
as a string in the system.

Examples
/dig Dark Grotto

See Also: /describe, /open
EOS
  end
end
