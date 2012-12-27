require 'tinydungeon/systems/commands/command'

require 'tinydungeon/game_components'

require 'tinydungeon/systems/helpers/container_helper'
require 'tinydungeon/systems/helpers/link_helper'

class GotoCommand < Command
  include ContainerHelper, LinkHelper

  def initialize(system, look_command)
    super(system)
    @look_command = look_command
  end

  def execute(cmd)
    direction = rest(cmd.line)
    person = cmd.entity
    room = room_for(person)
    link = link_for(room, direction)

    if !link
      say_to_player(person, "No such exit")
    else
      direction_label = link.one(Name).value
      say_to_room person, "#{person.one(Name).value} went #{direction_label}."
      say_to_player person, "You go #{direction_label}"
      exit_ref = link.one(LinkRef)

      if !exit_ref
        # FIXME: Add unlink fail/ofail stuff.
      else
        new_room = manager[exit_ref.value] # FIXME: Error handling for this
        person.one(ContainedBy).value = new_room.uuid
        new_room.add Containee.new(person.uuid)
        # FIXME: find then delete since an object should only exist in one place
        Containee.for(room).each { |l| l.delete if l.value == person.uuid }
      end
      @look_command.execute(cmd)
    end
  end

  def description
    "Try to go through an exit"
  end

  def usage
    "goto {direction}"
  end

  def help
    super + <<EOS

{object} can be number, name, 'here', or 'me'.  If you omit
={description} then it just displays the current description.

Examples
@describe me=Quite a fella
@describe me

EOS
  end
end

