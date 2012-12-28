require 'tinydungeon/systems/commands/command'

class QuitCommand < Command
  def execute(cmd)
    player = cmd.entity

    last_room = player.one(ContainedBy)
    player.add LastContainedBy.new(last_room)
    
    last_room_entity = manager[last_room]
    Containee.for(last_room_entity) do |c|
      c.delete if c.same? player.uuid
    end
    player.delete last_room
    
    
    game.connections[player] = nil
  end

  def description
    "quit the game"
  end

  def usage
    "quit"
  end
end
