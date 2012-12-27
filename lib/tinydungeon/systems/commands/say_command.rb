require 'tinydungeon/systems/commands/command'

class SayCommand < Command
  def execute(cmd)
    say cmd.entity, cmd.value
  end

  def description
    "say something to the room"
  end

  def usage
    "say {message} OR {message}"
  end
end
