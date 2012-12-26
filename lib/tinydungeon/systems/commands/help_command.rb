require 'tinydungeon/systems/commands/command'

class HelpCommand < Command
  def initialize(system, commands)
    @commands = commands
  end

  def execute(cmd)
    command_name = rest(cmd.line)
    if command_name
      command = @commands[command_name.strip]
      if !command
        say_to_player cmd.entity, "No such command for help: #{command_name.strip}"
      else
        say_to_player cmd.entity, command.help
      end
    else
      help = @commands.sort.inject do |s, (k, v)|
        s << "#{v.usage}\n"
        s << "    #{v.description}\n"
      end
      say_to_player cmd.entity, help
    end
  end

  def description
    "provides help"
  end

  def usage
    "help [{command_name}]?"
  end

  def help
    super + <<EOS

You can get a generic list of all commands or specific help on a command.

Examples
@help            # all help
@help @describe  # detailed help on describe

EOS
  end
end
