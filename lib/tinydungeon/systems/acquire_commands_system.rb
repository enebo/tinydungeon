require 'wreckem/system'

require 'tinydungeon/components/command'
require 'tinydungeon/components/player'

class AcquireCommandsSystem < Wreckem::System
  def initialize(game)
    super(game)
  end

  def process
    Player.all do |player|
      print "> "
      player.entity.add Command.new($stdin.gets.chomp)
    end
  end
end
