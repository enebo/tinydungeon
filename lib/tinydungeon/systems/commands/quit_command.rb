require 'tinydungeon/systems/commands/command'

class QuitCommand < Command
  def execute(cmd)
    exit 0
  end

  def description
    "quit the game"
  end

  def usage
    "QUIT"
  end
end
