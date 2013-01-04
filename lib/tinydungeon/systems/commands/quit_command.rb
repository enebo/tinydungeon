require 'tinydungeon/systems/commands/command'

class QuitCommand < Command
  def execute(cmd)
    player = cmd.entity

    last_room = player.one(ContainedBy)
    last_room.to_entity.many(Containee) { |c| c.delete if c.same? player.id }
    last_room.delete
    player.one(Online).delete
    
    game.connections[player.id].logout
  end

  def description
    "quit the game"
  end

  def usage
    "/quit"
  end
end
