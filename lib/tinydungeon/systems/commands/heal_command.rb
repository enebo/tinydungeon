require 'tinydungeon/systems/commands/command'

require 'tinydungeon/game_components'

class HealCommand < Command
  def execute(cmd)
    player = cmd.entity
    hp = player.one(HitPoints)
    max_hp = player.one(MaxHitPoints)

    if hp.value == max_hp.value
      output_you player, "You are already at full health."
      return
    end

    heal_amount = rand(4) + 1
    
    new_hp = hp.value + heal_amount
    new_hp = max_hp.value if new_hp > max_hp.value
    heal_amount = new_hp - hp.value
    
    hp.value = new_hp
    hp.save
    
    output_you player, "You have healed yourself for #{heal_amount} point."
  end
end
