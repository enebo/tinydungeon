require 'tinydungeon/systems/commands/command'

require 'tinydungeon/game_components'

class WhoCommand < Command
  def execute(cmd)
    player = cmd.entity
    specific = rest(cmd)

    if specific &&
        Player.all.map(&:entity).find { |p| p.one(Name).same?(specific) }
      output_you player, "Player #{specific} is online."
    else
      list = Player.all.map(&:entity).inject([]) do |l, peep|
        l << peep.one(Name) if !peep.is?(LastContainedBy)
        l
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
