require 'tinydungeon/systems/commands/command'

require 'tinydungeon/game_components'
require 'tinydungeon/systems/helpers/link_helper'

class LookCommand < Command
  include LinkHelper

  def execute(cmd)
    player = cmd.entity
    room = manager[player.one(ContainedBy)]
    message = <<-EOS
#{room.one(Name)} - #{room.one(Description)}

Things here:
    EOS

    Containee.for(room) do |l|
      e = manager[l]
      you = e == player ? '[you]' : ''
      message << "   #{e.one(Name)} - #{e.one(Description)} #{you}\n"
    end

    links = link_names(room)

    message << "\nExits: #{links.join(', ')}\n" unless links.empty?

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
