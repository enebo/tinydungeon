require 'tinydungeon/components/contained_by'
require 'tinydungeon/components/message'
require 'tinydungeon/components/name'

class Command
  attr_reader :system

  def initialize(system)
    @system = system
  end

  ##
  # behavior for the command
  def execute(cmd)
  end

  ##
  # return one-line description for help
  def description
  end

  ##
  # return usage string for help and for error reporting
  def usage
  end

  ##
  # return multi-line specific help for the command
  def help
    <<EOS
#{description}"

Usage: #{usage}
EOS
  end

  def game
    system.game
  end

  def manager
    system.manager
  end

  def namedb
    system.namedb
  end

  def say_to_player(sender, msg)
    sender.add Message.new(sender.one(ContainedBy).uuid, msg)
  end

  # Let the room and all items in the room hear what you said (except you)
  def say_to_room(sender, msg)
    room_uuid = sender.one(ContainedBy).uuid
    room = manager[room_uuid]

    room.add Message.new(room_uuid, msg)

    Containee.for(room).each do |l|
      entity = manager[l.uuid]
      entity.add Message.new(room_uuid, msg) if entity != sender
    end
  end

  def name_to_object_info(issuer, name)
    if name == "here"
      entity = manager[issue.one(ContainedBy).uuid]
      name = entity.one(Name)
      num = namedb.name_map[name]
    elsif name =~ /^\d+$/
      num = name.to_i
      entity = manager[namedb.num_map[num]]
      name = entity.one(Name)
    else
      num = namedb.name_map[name]
      entity = manager[namedb.num_map[num]]
    end
    [name, num, entity]
  end

  def room_for(entity)
    manager[entity.one(ContainedBy).uuid]
  end

  def rest(line)
    line.split(/\s+/, 2)[1]
  end
end
