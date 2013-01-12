require 'wreckem/game'
require 'wreckem/entity_manager'
require 'wreckem/backends/memory'
require 'wreckem/backends/stat_wrapper'

require 'tinydungeon/game_components'
require 'tinydungeon/player_connection'

require 'tinydungeon/systems/helpers/container_helper'
require 'tinydungeon/systems/helpers/link_helper'

require 'tinydungeon/systems/acquire_commands_system'
require 'tinydungeon/systems/combat_system'
require 'tinydungeon/systems/process_commands_system'
require 'tinydungeon/systems/hear_things_system'

class TinyDungeon < Wreckem::Game
  attr_reader :connections, :players, :entry
  include ContainerHelper, LinkHelper

  attr_reader :stats

  def initialize
    @stats = Wreckem::StatWrapper.new(Wreckem::SequelStore.new)
    super(@stats)

    # We keep these mappings out of our EC system since they are transient
    # and full socket objects
    @connections = {} # {socket => Players}
    @players = {}     # {player.id => Players}
  end

  def register_entities
    unless Entry.all.to_a.empty? # Entry room is a required component
      @entry = Entry.all.to_a.first.entity
      return
    end

    @entry = create_room("Echo Chamber", "A round domed room").tap do |room|
      room.is Entry, Echo
    end

    @admin = create_player("Neo", "The one", nil)
    @entry.has Owner.new(@admin) # bootstrapping...who came first

    create_monster('Goblozowie', 'A green goblin', @entry, @admin)
    create_monster('Goblobowie', 'A green goblin', @entry, @admin)
  end

  def register_async_systems
    async_systems << AcquireCommandsSystem.new(self)
  end

  def register_systems
    process_commands_system = ProcessCommandsSystem.new(self)
    systems << process_commands_system
    systems << CombatSystem.new(self)
    systems << HearThingsSystem.new(self, process_commands_system.commands)
  end

  # Creators/Templates
  def create_player(name=nil, description=nil, room=entry)
    create_object(name, description, @admin).tap do |player|
      player.is Player, Container
      player.has HitPoints.new(5)
      player.has AttackStat.new(5)
      player.has DefenseStat.new(5)
      add_to_container(room, player) if room
    end
  end
  
  def create_monster(name, description, room, owner)
    create_object(name, description, owner).tap do |mob|
      mob.is NPC
      mob.has HitPoints.new(5)
      mob.has AttackStat.new(4)
      mob.has DefenseStat.new(4)
      add_to_container(room, mob)
    end    
  end

  def create_object(name, description='', owner=nil)
    Wreckem::Entity.is! do |e|
      e.has Name.new(name)
      e.has Description.new(description)
      e.has Owner.new(owner) if owner
    end
  end

  def create_room(name, description, owner=nil)
    create_object(name, description, owner=nil).tap do |room|
      room.is Container
      room.has ContainedBy.new(room) # FIXME: say from room to others hack
    end
  end
end
