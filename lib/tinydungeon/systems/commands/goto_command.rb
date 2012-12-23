require 'tinydungeon/systems/commands/command'

require 'tinydungeon/components/contained_by'
require 'tinydungeon/components/containee'
require 'tinydungeon/components/link'

class GotoCommand < Command
  def initialize(system, look_command)
    super(system)
    @look_command = look_command
  end

  def execute(cmd)
    direction = rest(cmd.line)
    person = cmd.entity
    room = room_for(person)
    link = Link.for(room).find {|link| link.directions.include?(direction) }

    if !link
      say "No such exit"
    else
      new_room = manager[link.destination]
      ContainedBy.one_for(person).uuid = new_room.uuid
      new_room.add Containee.new(person.uuid)
      # FIXME: find then delete since an object should only exist in one place
      Containee.for(room).each { |l| l.delete if l.uuid == person.uuid }

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

