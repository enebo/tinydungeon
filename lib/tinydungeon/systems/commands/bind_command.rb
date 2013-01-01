require 'tinydungeon/systems/commands/command'

require 'tinydungeon/game_components'

class BindCommand < Command
  def execute(cmd)
    player = cmd.entity
    room = Wreckem::Entity.find(player.one(ContainedBy))

    bind = player.one(BindRoom)

    if bind
      message = "Changing Bind room from #{bind.one(Name)} to #{room.one(Name)}"
      bind.update!(room.id)
    else
      message = "Bind room set to #{room.one(Name)}"
      player.has BindRoom.new(room.id)
    end
    
    output_you player, message
  end

  def description
    "Set your starting room to this room"
  end

  def usage
    "/bind"
  end
end
