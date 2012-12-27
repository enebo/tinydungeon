module LinkHelper
  def create_link(source_room, destination_room=nil, directions)
    direction, *aliases = *directions
    manager.create_entity do |e|
      e.is Link
      e.has Name.new(direction)
      aliases.each do |direction_alias|
        e.has NameAlias.new(direction_alias)
      end
      e.has LinkRef.new(destination_room.uuid) if destination_room
      source_room.has LinkRef.new(e.uuid)
    end
  end

  def link_for(room, direction)
    LinkRef.for(room) do |linkref|
      link = manager[linkref]  # FIXME: How to deal with bad data?

      return link if link.one(Name).value == direction
      
      NameAlias.for(link) do |name_alias|
        return link if name_alias.value == direction
      end
    end
    nil
  end

  def link_names(room)
    list = []
    LinkRef.for(room) do |linkref|
      list << manager[linkref].one(Name).to_s
    end
    list
  end
end
