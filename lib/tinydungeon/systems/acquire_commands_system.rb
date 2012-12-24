require 'wreckem/system'

require 'tinydungeon/components/command_line'
require 'tinydungeon/components/player'

class AcquireCommandsSystem < Wreckem::System
  def initialize(game)
    super(game)
  end

  def process
    Player.entities do |player|
      print "> "
      player.add CommandLine.new($stdin.gets.chomp)
    end
  end
end
