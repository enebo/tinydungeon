require 'tinydungeon/systems/commands/command'

class SayCommand < Command
  def execute(cmd)
    say_to_player cmd.entity, "You say, '#{cmd.value}'"
    say_to_room cmd.entity, "#{cmd.value}"
  end

  def description
    "say something to the room"
  end

  def usage
    "say {message} OR {message}"
  end
end
