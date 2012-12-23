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
        puts "No such command for help: #{command_name.strip}"
      else
        puts command.help
      end
    else
      @commands.sort.each do |k, v|
        puts "#{v.usage}"
        puts "    #{v.description}"
      end
    end
  end

  def description
    "provides help"
  end

  def usage
    "help [{command_name}]?"
  end

  def help
    <<EOS
#{description}

Usage: #{usage}

You can get a generic list of all commands or specific help on a command.

Examples
@help            # all help
@help @describe  # detailed help on describe

EOS
  end
end
