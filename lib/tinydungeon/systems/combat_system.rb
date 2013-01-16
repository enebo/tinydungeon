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
    @attack_mod, @defense_mod, @level_mod = game.combat_constants.one(AttackMod, DefenseMod, LevelMod).map(&:value)
  end
  
  def process
    return if Time.now - @time <= COMBAT_TICK
    
    @time = Time.now

    list = []
    CombatWithRef.intersects(AttackStat, Level) do |combat_with, attack, level|
      list << [combat_with, attack.value, level.value]
    end
    
    list.sort { |a, b| a[1] <=> b[1] }.each do |combat_with, attacker_attack, attacker_level|
      attacker, defender = combat_with.entity, combat_with.to_entity
      defender_name, defender_defense, defender_hp, defender_level = defender.one(Name, DefenseStat, HitPoints, Level)
      hp = defender_hp.value

      # FIXME: Ordering might be useful in query
      # FIXME: Attacker who has died still can land a blow
      # Only allow attacker to land blow if they still have any hps left
      if hp <= 0
        combat_with.delete
        next
      end
      
      attacker_name = attacker.one(Name)
      
      if hit!(attacker_level, defender_level.value, attacker_attack, defender_defense.value)
        damage = 1
        defender_hp.value = hp - damage
        defender_hp.save
        
        output_you attacker, "You hit #{defender_name} for #{damage} points."        
        output_others attacker, "#{attacker_name} hits #{defender_name} for #{damage} points."
        
        if defender_hp.value <= 0
          output_you attacker, "#{defender_name} has died."
          output_others attacker, "#{defender_name} has died."
          defender.many(CombatWithRef).each { |dcw| dcw.delete }   # The dead fight no more
          combat_with.delete                                       # stop fighting the dead
        end
      else
        output_you attacker, "You miss #{defender_name}."
        output_others attacker, "#{attacker_name} misses #{defender_name}."
      end
    end
  end
  
  def hit!(a_level, b_level, a_attack, b_defense)
    puts "a_level #{a_level}, b_level #{b_level}, a_attack #{a_attack} b_defense #{b_defense}"
    level_percentage = (a_level * @level_mod) - (b_level * @level_mod)
    stuff_percentage = (a_attack * @attack_mod) - (b_defense * @defense_mod)
    rand_value = rand
    result = (level_percentage + stuff_percentage + 0.5)
    
    puts "RV #{rand_value}, RS: #{result} LP #{level_percentage} SP #{stuff_percentage}"
    rand_value < result
  end
end