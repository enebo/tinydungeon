require 'wreckem/system'

require 'tinydungeon/game_components'

require 'tinydungeon/systems/commands/bind_command'
require 'tinydungeon/systems/commands/create_command'
require 'tinydungeon/systems/commands/describe_command'
require 'tinydungeon/systems/commands/drop_command'
require 'tinydungeon/systems/commands/dig_command'
require 'tinydungeon/systems/commands/entity_examine_command'
require 'tinydungeon/systems/commands/examine_command'
require 'tinydungeon/systems/commands/get_command'
require 'tinydungeon/systems/commands/goto_command'
require 'tinydungeon/systems/commands/help_command'
require 'tinydungeon/systems/commands/inventory_command'
require 'tinydungeon/systems/commands/look_command'
require 'tinydungeon/systems/commands/open_command'
require 'tinydungeon/systems/commands/quit_command'
require 'tinydungeon/systems/commands/rm_command'
require 'tinydungeon/systems/commands/save_command'
require 'tinydungeon/systems/commands/say_command'
require 'tinydungeon/systems/commands/tell_command'
require 'tinydungeon/systems/commands/who_command'

class ProcessCommandsSystem < Wreckem::System
  attr_reader :commands, :aliases

  def initialize(game)
    super(game)

    @commands, @aliases = {}, {}

    [BindCommand, BindCommand, CreateCommand, DescribeCommand, DigCommand,
     DropCommand, EntityExamineCommand, ExamineCommand, GetCommand, GotoCommand,
     HelpCommand, InventoryCommand, LookCommand, OpenCommand, QuitCommand,
     RmCommand, SaveCommand, SayCommand, TellCommand, WhoCommand].each do |c|
      c.register(self)
    end

    @commands['/goto'].look_command = @commands['/look']
  end

  def process
    CommandLine.all.each do |cmd|
      next unless /(?<command>[\S]+)/ =~ cmd.value
      object = @commands[command] || @aliases[command] || @commands['/say']
      cmd.delete
      begin
        object.execute(cmd)
      rescue 
        puts "PUTS: #{cmd.entity.as_string}"
      end
    end
  end
end
