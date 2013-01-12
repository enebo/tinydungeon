require 'tinydungeon/systems/commands/command'

require 'tinydungeon/game_components'

class LookCommand < Command
  def execute(cmd)
    player = cmd.entity
    room = Wreckem::Entity.find(player.one(ContainedBy))
    message = "\n#{label_for(room)}\n\nThings here:\n"

    each_container_entity(room) do |e|
      message << "   #{label_for(e)} #{e == player ? '[you]' : ''}\n"
    end
    message << "\n"

    links = link_display_names(room)

    message << "Exits: #{links.join(', ')}\n" unless links.empty?

    output_you player, message
  end

  def label_for(entity)
    hit_points = entity.one(HitPoints)

    if hit_points
      maxhp, name, description = entity.one(MaxHitPoints, Name, Description).map(&:value)
       "(\##{entity.id}) #{name} - #{description} [hp: #{hit_points} of #{maxhp}]"
    else
      name, description = entity.one(Name, Description).map(&:value)
      "(\##{entity.id}) #{description} - #{name}"
    end
  end

  def description
    "Display contents of current room"
  end

  def usage
    "/look"
  end

  def help
    super + <<-EOS

The room name and description are printed along with two possible lists.
The first list is all the items and players which happen to be in the room.
The second list will contain any exits which may be present.
EOS
  end
end
