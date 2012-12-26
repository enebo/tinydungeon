require 'tinydungeon/systems/commands/command'

require 'tinydungeon/components/contained_by'
require 'tinydungeon/components/containee'
require 'tinydungeon/components/description'
require 'tinydungeon/components/link'
require 'tinydungeon/components/name'

require 'tinydungeon/components/command_line'

class LookCommand < Command
  def execute(cmd)
    player = cmd.entity
    room = manager[ContainedBy.one_for(player).uuid]
    title, desc = Name.one_for(room), Description.one_for(room)

    message = <<-EOS
#{title.value} - #{desc.value}

Things here:
    EOS

    Containee.for(room) do |l|
      e = manager[l.uuid]
      name, desc = Name.one_for(e), Description.one_for(e)
      message << "   #{name.value} - #{desc.value} #{e == player ?'[you]':''}\n"
    end

    links = Link.for(room)
    unless links.empty?
      message << "\nExits: "
      message << links.map { |link| link.directions[0] }.join(", ")
      message << "\n"
    end
    say_to_player player, message
  end

  def description
    "Display contents of current room"
  end

  def usage
    "look"
  end

  def help
    super + <<-EOS

The room name and description are printed along with two possible lists.
The first list is all the items and players which happen to be in the room.
The second list will contain any exits which may be present.
EOS
  end
end
