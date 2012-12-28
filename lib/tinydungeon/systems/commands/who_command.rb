require 'tinydungeon/systems/commands/command'

require 'tinydungeon/game_components'

class WhoCommand < Command
  def execute(cmd)
    player = cmd.entity
    specific = rest(cmd)

    if specific
      Player.all do |p|
        peep = p.entity

        if peep.one(Name).same?(specific)
          output_you player, "Player #{specific} is online."
          break
        end
      end
    else
      list = []
      Player.all do |p|
        peep = p.entity
        list << peep.one(Name) if !peep.is?(LastContainedBy)
      end
      
      output_you player, "Players online: #{list.join(', ')}."
    end
  end

  def description
    "Display currently connected players or if an individual is on"
  end

  def usage
    "/who [player]"
  end

  def help
    super + <<-EOS

Useful to know when friends are online
EOS
  end
end
