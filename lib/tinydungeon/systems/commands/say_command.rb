require 'tinydungeon/systems/commands/command'

class SayCommand < Command
  def execute(cmd)
    puts "You say, '#{cmd.line}'"
  end

  def description
    "say something to the room"
  end

  def usage
    "say {message} OR {message}"
  end
end
