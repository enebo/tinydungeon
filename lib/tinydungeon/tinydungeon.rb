require 'wreckem'
require 'wreckem/game'
require 'wreckem/entity_manager'

require 'tinydungeon/components/contained_by'
require 'tinydungeon/components/containee'
require 'tinydungeon/components/container'
require 'tinydungeon/components/description'
require 'tinydungeon/components/name'
require 'tinydungeon/components/namedb'
require 'tinydungeon/components/npc'
require 'tinydungeon/components/player'

require 'tinydungeon/systems/acquire_commands_system'
require 'tinydungeon/systems/process_commands_system'

class TinyDungeon < Wreckem::Game
  def register_entities
    manager.create { |e| e.has NameDB.new }

    room = create_room("Entry", "a room with stone walls and a musty smell")

    player = create_object('Vorne', 'A dashing adventurer')
    player.is Player
    player.has ContainedBy.new(room.uuid)
    room.add Containee.new(player.uuid)

    goblin = create_object('Goblozowie', "a green, nasty looking goblin")
    goblin.is NPC
    goblin.has ContainedBy.new(room.uuid)
    room.add Containee.new(goblin.uuid)
  end

  def register_systems
    systems << AcquireCommandsSystem.new(self)
    systems << ProcessCommandsSystem.new(self)
  end

  # Creators/Templates

  def create_object(name, description)
    obj_name = Name.new(name)
    obj = manager.create do |e|
      e.has obj_name
      e.has Description.new(description)
    end

    # FIXME: This will never work across threads (ok?)
    # tinymud mapping between name,number, and uuid
    namedb = NameDB.all[0]
    number = namedb.next_number
    namedb.name_map[obj_name.value] = number
    namedb.next_number += 1
    namedb.num_map[number] = obj.uuid

    obj
  end

  def create_room(name, description)
    create_object(name, description).tap do |room|
      room.is Container
    end
  end
end
