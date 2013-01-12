require 'tinydungeon/systems/commands/command'

require 'tinydungeon/game_components'

class AttackCommand < Command
  def execute(cmd)
    name = rest(cmd)
    person = cmd.entity
    room = container_for(person)
    
    found = nil
    each_container_entity(room) do |object|
      if object.is?(NPC) && (object.one(Name).same?(name) || object.id == name.to_i)
        found = object
        break
      end
    end

    if found
      person.has CombatWithRef.new(found)
      found.has CombatWithRef.new(person)
      
      output_you person, "You start attacking #{found.one(Name)}."
      output_others person, "#{person.one(Name)} starts attacking #{found.one(Name)}."
    else
      output_you person, "Nothing to attack named #{name}"
    end
  end
end
