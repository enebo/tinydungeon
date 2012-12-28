require 'tinydungeon/systems/commands/command'

class CreateCommand < Command
  def execute(cmd)
    name = rest(cmd)
    obj = game.create_object(name, '', cmd.entity).tap do |o|
      o.is NormalObject
    end
    name, num, entity = name_to_object_info(cmd.entity, name)
    add_to_container(cmd.entity, obj) 
    output_you cmd.entity, "Created an object named: #{name} (\##{num})"
  end

  def description
    "Create an object"
  end

  def usage
    "@create {name}"
  end

  def help
    super + <<EOS

{name} can be almost any string so long as it does not already exist
as a string in the system.

Examples
@create Pencil

See Also: @describe
EOS
  end
end
