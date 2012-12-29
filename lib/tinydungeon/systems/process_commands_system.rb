require 'wreckem/system'

require 'tinydungeon/game_components'

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
require 'tinydungeon/systems/commands/save_command'
require 'tinydungeon/systems/commands/say_command'
require 'tinydungeon/systems/commands/tell_command'
require 'tinydungeon/systems/commands/who_command'

class ProcessCommandsSystem < Wreckem::System
  attr_reader :commands

  def initialize(game)
    super(game)

    @commands = {
      '/create' => CreateCommand.new(self),
      '/describe' => DescribeCommand.new(self),
      '/dig' => DigCommand.new(self),
      '/rop' => DropCommand.new(self),
      '/entity_examine' => EntityExamineCommand.new(self),
      '/examine' => ExamineCommand.new(self),
      '/get' => GetCommand.new(self),
      '/inventory' => InventoryCommand.new(self),
      '/look' => LookCommand.new(self),
      '/open' => OpenCommand.new(self),
      '/quit' => QuitCommand.new(self),
      '/save' => SaveCommand.new(self),
      '/say' => SayCommand.new(self),
      '/tell' => TellCommand.new(self),
      '/who' => WhoCommand.new(self),
    }
    @commands['/goto'] = GotoCommand.new(self, @commands['/look'])
    @commands['/help'] = HelpCommand.new(self, @commands)
  end

  def process
    CommandLine.all.each do |cmd|
      next unless /(?<command>[\S]+)/ =~ cmd.value
      object = @commands[command] || @commands['/say']
      cmd.delete
      object.execute(cmd)
    end
  end
end
