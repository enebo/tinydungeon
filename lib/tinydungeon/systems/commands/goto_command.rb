require 'tinydungeon/game_components'

require 'tinydungeon/systems/commands/command'

class GotoCommand < Command
  attr_accessor :look_command

  def execute(cmd)
    direction = rest(cmd)
    person = cmd.entity
    room = container_for(person)
    link = link_for(room, direction)

    puts "LINK FOUND: #{link.as_string}"

    if !link
      output_you person, "No such exit"
    else
      direction_label = link.one(Name)
      output_others person, "#{person.one(Name)} went #{direction_label}."
      output_you person, "You go #{direction_label}"
      exit_ref = link.one(LinkRef)

      if !exit_ref
        # FIXME: Add unlink fail/ofail stuff.
      else
        # FIXME: Error handling for this
        new_room = Wreckem::Entity.find(exit_ref) 
        swap_containers(room, new_room, person)
        output_others person, "#{person.one(Name)} enters the room."
      end
      @look_command.execute(cmd)
    end
  end

  def description
    "Try to go through an exit"
  end

  def usage
    "/goto {direction}"
  end

  def help
    super + <<EOS

{object} can be number, name, 'here', or 'me'.  If you omit
={description} then it just displays the current description.

Examples
/goto north

EOS
  end
end

