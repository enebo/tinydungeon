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
  attr_reader :connections, :players, :entry, :combat_constants
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
      @combat_constants = CombatConstants.all.to_a.first.entity
      return
    end

    @entry = create_room("Echo Chamber", "A round domed room").tap do |room|
      room.is Entry, Echo
    end

    @admin = create_player("Neo", "The one", nil)
    @entry.has Owner.new(@admin) # bootstrapping...who came first

    create_monster('Goblozowie', 'A green goblin', 1, @entry, @admin)
    create_monster('Goblobowie', 'A green goblin', 2, @entry, @admin)
    create_monster('Orciepop', 'A blue Orc', 3, @entry, @admin)
    create_monster('Orcjagger', 'A blue Orc', 4, @entry, @admin)
    
    @combat_constants = Wreckem::Entity.is! do |e|
      e.has LevelMod.new 0.12
      e.has AttackMod.new 0.01
      e.has DefenseMod.new 0.01
    end
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
      player.has Level.new(1)
      create_combat_stats(player, 5, 5, 5)
      add_to_container(room, player) if room
    end
  end
  
  def create_stat(entity, type, max_type, value)
    entity.has type.new(value)
    entity.has max_type.new(value)
  end
  
  def create_combat_stats(entity, hp_value, attack_value, defense_value)
    create_stat(entity, HitPoints, MaxHitPoints, hp_value)
    create_stat(entity, AttackStat, MaxAttackStat, attack_value)
    create_stat(entity, DefenseStat, MaxDefenseStat, defense_value)
  end
  
  def create_monster(name, description, level, room, owner)
    create_object(name, description, owner).tap do |mob|
      mob.is NPC
      mob.has Level.new(level)
      create_combat_stats(mob, 6, 6, 6)
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
    create_object(name, description, owner).tap do |room|
      room.is Container
      room.has ContainedBy.new(room) # FIXME: say from room to others hack
    end
  end
end
