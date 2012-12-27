require 'wreckem/system'

require 'tinydungeon/game_components'

require 'tinydungeon/systems/commands/describe_command'
require 'tinydungeon/systems/commands/dig_command'
require 'tinydungeon/systems/commands/goto_command'
require 'tinydungeon/systems/commands/help_command'
require 'tinydungeon/systems/commands/look_command'
require 'tinydungeon/systems/commands/open_command'
require 'tinydungeon/systems/commands/quit_command'
require 'tinydungeon/systems/commands/save_command'
require 'tinydungeon/systems/commands/say_command'

class ProcessCommandsSystem < Wreckem::System
  attr_reader :namedb, :commands

  def initialize(game)
    super(game)

    @namedb = NameDB.all[0]
    @commands = {
      '@describe' => DescribeCommand.new(self),
      '@dig' => DigCommand.new(self),
      'look' => LookCommand.new(self),
      '@open' => OpenCommand.new(self),
      'QUIT' => QuitCommand.new(self),
      'save' => SaveCommand.new(self),
      'say' => SayCommand.new(self),
    }
    @commands['goto'] = GotoCommand.new(self, @commands['look'])
    @commands['help'] = HelpCommand.new(self, @commands)
  end

  def process
    CommandLine.all do |cmd|
      next unless /(?<command>[\S]+)/ =~ cmd.line
      object = @commands[command] || @commands['say']
      cmd.delete
      object.execute(cmd)
    end
  end
end
