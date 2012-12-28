require 'wreckem'
require 'wreckem/game'
require 'wreckem/entity_manager'

require 'tinydungeon/game_components'

require 'tinydungeon/systems/helpers/container_helper'
require 'tinydungeon/systems/helpers/link_helper'

require 'tinydungeon/systems/acquire_commands_system'
require 'tinydungeon/systems/process_commands_system'
require 'tinydungeon/systems/hear_things_system'

class TinyDungeon < Wreckem::Game
  attr_reader :connections, :players, :entry
  include ContainerHelper, LinkHelper

  def initialize
    super()

    # We keep these mappings out of our EC system since they are transient
    # and full socket objects
    @connections = {}
    @players = {}
  end

  def register_entities
    if manager.size > 0 # Already loaded..hacky
      @entry = Entry.add[0].entity
      return 
    end

    manager.create_entity { |e| e.has NameDB.new }

    @entry = create_room("Echo Chamber", "A round domed room").tap do |room|
      room.is Entry, Echo
    end

    @admin = create_player("Neo", "The one", nil)
    @entry.has Owner.new(@admin) # bootstrapping...who came first

    create_object('Goblozowie', "A green goblin", @admin).tap do |goblin|
      goblin.is NPC
      add_to_container(@entry, goblin)
    end
  end

  def register_async_systems
    async_systems << AcquireCommandsSystem.new(self)
  end

  def register_systems
    process_commands_system = ProcessCommandsSystem.new(self)
    systems << process_commands_system
    systems << HearThingsSystem.new(self, process_commands_system.commands)
  end

  # Creators/Templates
  def create_player(name=nil, description=nil, room=entry)
    create_object(name, description, @admin).tap do |player|
      player.is Player
      add_to_container(room, player) if room
      player.is Container
    end
  end

  def create_object(name, description, owner=nil)
    obj_name = Name.new(name)
    obj = manager.create_entity do |e|
      e.has obj_name
      e.has Description.new(description)
      e.has Owner.new(owner) if owner
    end

    # FIXME: This will never work across threads (ok?)
    # tinymud mapping between name,number, and uuid
    namedb = NameDB.all[0]
    number = namedb.next_number
    namedb.name_map[obj_name.value] = number
    namedb.next_number += 1
    namedb.num_map[number] = obj.uuid

    obj.has Num.new(number)

    obj
  end

  def create_room(name, description, owner=nil)
    room = create_object(name, description, owner=nil).tap do |room|
      room.is Container
      room.has ContainedBy.new(room.uuid) # FIXME: say from room to others hack
    end
  end
end
