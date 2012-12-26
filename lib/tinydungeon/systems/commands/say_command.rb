require 'tinydungeon/systems/commands/command'

class SayCommand < Command
  def execute(cmd)
    say_to_player cmd.entity, "You say, '#{cmd.line}'"
    say_to_room cmd.entity, "#{cmd.line}"
  end

  def description
    "say something to the room"
  end

  def usage
    "say {message} OR {message}"
  end
end
