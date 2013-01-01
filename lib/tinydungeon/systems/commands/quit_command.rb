require 'tinydungeon/systems/commands/command'

class QuitCommand < Command
  def execute(cmd)
    player = cmd.entity

    last_room = player.one(ContainedBy)
    player.add LastContainedBy.new(last_room)
    
    Wreckem::Entity.find(last_room).many(Containee) do |c|
      c.delete if c.same? player.id
    end
    last_room.delete
    
    game.connections[player.id] = nil
  end

  def description
    "quit the game"
  end

  def usage
    "/quit"
  end
end
