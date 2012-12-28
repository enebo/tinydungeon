require 'tinydungeon/systems/commands/command'

require 'tinydungeon/game_components'
require 'tinydungeon/systems/helpers/container_helper'
require 'tinydungeon/systems/helpers/link_helper'

class InventoryCommand < Command
  def execute(cmd)
    player = cmd.entity

    message = "\nYou have:\n"
    each_container_entity(player) { |e| message << "   #{label_for(e)}\n" }
    message << "\n"

    output_you player, message
  end

  def label_for(entity)
    "(\##{entity.one(Num)}) #{entity.one(Name)} - #{entity.one(Description)}"
  end

  def description
    "Display your inventory"
  end

  def usage
    "/inventory"
  end

  def help
    super + <<-EOS

Shows all your stuff
EOS
  end
end
