require 'wreckem/system'

require 'tinydungeon/game_components'
require 'tinydungeon/systems/helpers/container_helper'
require 'tinydungeon/systems/helpers/message_helper'

class CombatSystem < Wreckem::System
  include ContainerHelper, MessageHelper
  
  COMBAT_TICK = 4
  
  def initialize(game)
    super(game)
    @time = Time.now - COMBAT_TICK
  end
  
  def process
    return if Time.now - @time <= COMBAT_TICK
    
    @time = Time.now

    list = []
    CombatWithRef.intersects(AttackStat, HitPoints) do |combat_with, attack|
      list << [combat_with, attack.value]
    end
    
    list.sort { |a, b| a[1] <=> b[1] }.each do |combat_with, attacker_attack|
      attacker = combat_with.entity
      defender = combat_with.to_entity
      defender_defense = defender.one(DefenseStat).value
      defender_hp = defender.one(HitPoints)
      
      hp = defender_hp.value

      next if hp <= 0 # Only allow attacker to land blow if they still have any hps left
      
      if (defender_defense < attacker_attack)
        damage = attacker_attack - defender_defense
        defender_hp.value = hp - damage
        defender_hp.save
        
        output_you attacker, "You hit #{defender.one(Name)} for #{damage} points."        
        output_others attacker, "#{attacker.one(Name)} hits #{defender.one(Name)} for #{damage} points."
        
        if defender_hp.value <= 0
          output_you attacker, "#{defender.one(Name)} has died."
          output_others attacker, "#{defender.one(Name)} has died."
          defender.many(CombatWithRef).each { |dcw| dcw.delete }   # The dead fight no more
          combat_with.delete                                    # stop fighting the dead
        end
      else
        output_you attacker, "You miss #{defender.one(Name)}."
        output_others attacker, "#{attacker.one(Name)} misses #{defender.one(Name)}."
      end
    end
  end
end