require 'tinydungeon/game_components'

require 'tinydungeon/systems/commands/command'

class DropCommand < Command
  def execute(cmd)
    name = rest(cmd)
    person = cmd.entity

    dropped = nil
    each_container_entity(person) do |object|
      if object.is?(NormalObject) && object.one(Name).same?(name)
        swap_containers(person, container_for(person), object)
        dropped = object
        break
      end
    end

    if dropped
      name = dropped.one(Name)
      output_you person, "You drop #{name}."
      output_others person, "#{person.one(Name)} dropped '#{name}'."
    else
      output_you person, "No such item: #{name}."
    end
  end

  def description
    "Drop/sacrifice an item"
  end

  def usage
    "drop {object}"
  end

  def help
    super + <<EOS

{object} can be number or name of anything in your inventory.

Examples
@drop knife

See also inventory, get
EOS
  end
end

