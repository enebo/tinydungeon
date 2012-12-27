require 'tinydungeon/systems/commands/command'

class OpenCommand < Command
  def execute(cmd)
    line = rest(cmd)
    directions, num = line.split('=')
    directions = directions.split(';')

    destination_uuid = namedb.num_map[num.to_i]
    if !destination_uuid && num
      say_to_player cmd.entity, "Error: No such room number (\##{num})"
      return
    end

    destination = manager[destination_uuid]
    if container?(destination)
      source_room = container_for(cmd.entity)
      link = game.create_link(source_room, destination, directions)
    else 
      say_to_player cmd.entity, "You cannot open into a non-room"
      return
    end
    
    status = !num ? "Created unlinked exit" : 
      "Created exit to: #{link.one(Name).value}"
    say_to_player cmd.entity, status
  end

  def description
    "create link to a room"
  end

  def usage
    "@open [{dir}][;{other dir}]*[=number]"
  end

  def help
    super + <<EOS

You can open/create a linked or an unlinked exit.  In unlinked then trying 
to travel through it will give you an ofail message and everyone else will 
see the fail message.  If it is linked and you are now allowed to pass 
through then you will see the same fail behavior.  If you can travel through 
then you will see osuccess and others will see success.

Examples
@open north;n;no=3 # open an exit to room #3
@open south        # open an exit which is unlinked

EOS
  end
end
