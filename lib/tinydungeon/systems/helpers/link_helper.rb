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
    room.many(LinkRef).each do |linkref|
      link = manager[linkref]

      return link if link.one(Name).same? direction ||
        link.many(NameAlias).find { |nalias| nalias.same? direction }
    end
    nil
  end

  def link_names(room)
    room.many(LinkRef).inject([]) do |list, linkref|
      list << manager[linkref].one(Name).to_s
    end
  end
end
