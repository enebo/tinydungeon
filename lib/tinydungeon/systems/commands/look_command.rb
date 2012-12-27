require 'tinydungeon/systems/commands/command'

require 'tinydungeon/game_components'
require 'tinydungeon/systems/helpers/link_helper'

class LookCommand < Command
  include LinkHelper

  def execute(cmd)
    player = cmd.entity
    room = manager[player.one(ContainedBy)]
    message = "#{label_for(room)}\n\nThings here:\n"

    Containee.for(room) do |l|
      e = manager[l]
      you = e == player ? '[you]' : ''
      message << "   #{label_for(e)} #{you}\n"
    end
    message << "\n"

    links = link_names(room)

    message << "Exits: #{links.join(', ')}\n" unless links.empty?

    output_you player, message
  end

  def label_for(entity)
    "(\##{entity.one(Num)}) #{entity.one(Name)} - #{entity.one(Description)}"
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
