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
require 'tinydungeon/systems/hear_things_system'

class TinyDungeon < Wreckem::Game
  def register_entities
    return if manager.size > 0 # Already loaded..hacky
    manager.create_entity { |e| e.has NameDB.new }

    room = create_room("Echo Chamber", "A round domed room")
    room.is Echo

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
    process_commands_system = ProcessCommandsSystem.new(self)
    systems << process_commands_system
    systems << HearThingsSystem.new(self, process_commands_system.commands)
  end

  # Creators/Templates

  def create_object(name, description)
    obj_name = Name.new(name)
    obj = manager.create_entity do |e|
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
