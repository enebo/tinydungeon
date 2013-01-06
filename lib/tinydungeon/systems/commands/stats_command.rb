require 'tinydungeon/systems/commands/command'

class StatsCommand < Command
  def execute(cmd)
    output_you cmd.entity, game.stats.all_stats.inspect
  end

  def description
    "Save game state to a file"
  end

  def usage
    "/save {filename}"
  end
end
