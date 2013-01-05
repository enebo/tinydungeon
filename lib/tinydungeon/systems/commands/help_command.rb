require 'tinydungeon/systems/commands/command'

class HelpCommand < Command
  def execute(cmd)
    command_name = rest(cmd)
    if command_name
      command = @system.commands[command_name.strip]
      if !command
        output_you cmd.entity, "No such command for help: #{command_name.strip}"
      else
        output_you cmd.entity, command.help
      end
    else
      commands = @system.commands.keys.sort.inject([]) {|s,e| s << e; s }
      message = "Commands: #{commands.join(', ')}\n\n"
      message += "Type '/help {command_name}' for detailed help."
      output_you cmd.entity, message
    end
  end

  def description
    "provides help"
  end

  def usage
    "/help [{command_name}]?"
  end

  def help
    super + <<EOS

You can get a generic list of all commands or specific help on a command.

Examples
/help            # all help
/help /describe  # detailed help on describe

EOS
  end
end
