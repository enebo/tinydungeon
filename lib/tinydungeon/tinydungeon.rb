require 'wreckem/game'
require 'wreckem/entity_manager'
require 'wreckem/backends/memory'
require 'wreckem/backends/stat_wrapper'

require 'tinydungeon/game_components'

require 'tinydungeon/systems/helpers/container_helper'
require 'tinydungeon/systems/helpers/link_helper'

require 'tinydungeon/systems/acquire_commands_system'
require 'tinydungeon/systems/process_commands_system'
require 'tinydungeon/systems/hear_things_system'

class TinyDungeon < Wreckem::Game
  attr_reader :connections, :players, :entry
  include ContainerHelper, LinkHelper

#  attr_reader :stats

  def initialize
#    @stats = Wreckem::StatWrapper.new(Wreckem::MemoryStore.new)
#    super(@stats)
    super()

    # We keep these mappings out of our EC system since they are transient
    # and full socket objects
    @connections = {}
    @players = {}
  end

  def register_entities
    if manager.size > 0 # Already loaded..hacky
      @entry = Entry.all[0].entity
      return 
    end

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
    obj = manager.create_entity(name) do |e|
      e.has Name.new(name)
      e.has Description.new(description)
      e.has Owner.new(owner) if owner
    end
  end

  def create_room(name, description, owner=nil)
    room = create_object(name, description, owner=nil).tap do |room|
      room.is Container
      room.has ContainedBy.new(room) # FIXME: say from room to others hack
    end
  end
end
