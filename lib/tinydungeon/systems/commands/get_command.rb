require 'tinydungeon/game_components'

require 'tinydungeon/systems/commands/command'

class GetCommand < Command
  def execute(cmd)
    name = rest(cmd)
    person = cmd.entity
    room = container_for(person)

    found = nil
    each_container_entity(room) do |object|
      if object.is?(NormalObject) && object.one(Name).same?(name)
        swap_containers(room, person, object)
        found = object
        break
      end
    end

    if found
      name = found.one(Name)
      output_you person, "You pick up #{name}."
      output_others person, "#{person.one(Name)} picked up '#{name}'."
    else
      output_you person, "No such item: #{name}."
    end
  end

  def description
    "pick up an item"
  end

  def usage
    "/get {object}"
  end

  def help
    super + <<EOS

{object} can be number or name of anything in your inventory.

Examples
/get knife

See also /inventory, /drop
EOS
  end
end

