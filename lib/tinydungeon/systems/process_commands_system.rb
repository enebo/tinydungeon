require 'wreckem/system'

require 'tinydungeon/components/command'
require 'tinydungeon/components/description'
require 'tinydungeon/components/link'
require 'tinydungeon/components/name'

class ProcessCommandsSystem < Wreckem::System
  attr_reader :namedb

  def initialize(game)
    super(game)

    @namedb = NameDB.all[0]
  end

  COMMANDS = {
    '@describe' => :command_describe,
    '@dig' => :command_dig,
    'goto' => :command_goto,
    'help' => :command_help,
    'look' => :command_look,
    '@open' => :command_open,
    'say' => :command_say,
    'QUIT' => :command_quit,
  }

  def command_describe(cmd)
    name, description = rest(cmd.line).split(/\s*=\s*/, 2)
    name, num, entity = name_to_object_info(cmd.entity, name)
      
    if entity
      if cmd.line !~ %r{=(.*)}
        puts "#{name}(\##{num}) = #{Description.one_for(entity).value}"
      else
        Description.one_for(entity).value = description if entity
        puts "#{name}(\##{num}) changed to #{description}."
      end
    else
      puts "No such object named: #{name}"
    end
  end

  def command_dig(cmd)
    name = rest(cmd.line)
    room = game.create_room(name, '')
    name, num, entity = name_to_object_info(cmd.entity, name)
    puts "Created a room named: #{name} (\##{num})"
  end

  def command_goto(cmd)
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

      Containee.for(room).each do |l|
        l.delete if l.uuid == person.uuid
      end

      command_look(cmd)
    end
  end

  def command_help(cmd)
    puts <<-EOS
@describe [{object}][={description}] : see of set description of an object
@dig [{name}]                        : create a new room
goto {direction}                     : try to go through an exit 
help                                 : this help
look                                 : display contents of current room
@open [{dir}][;{other dir}]*[=number]: create link to a room 
QUIT                                 : quit the game

{object} can be the number, name, or 'here' for the current room.
EOS
  end

  def command_look(cmd)
    player = cmd.entity
    room = manager[ContainedBy.one_for(player).uuid]
    title, desc = Name.one_for(room), Description.one_for(room)

    puts "#{title.value} - #{desc.value}"
    puts ""
    puts "Thing here:"

    Containee.for(room) do |l|
      e = manager[l.uuid]
      name, desc = Name.one_for(e), Description.one_for(e)
      puts "   #{name.value} - #{desc.value} #{e == player ? '[you]' : ''}"
    end

    links = Link.for(room)
    unless links.empty?
      puts "Exits:"
      links.each do |link|
        puts "    #{link.directions[0]}"
      end
    end

  end

  # FIXME: num == nil is unlinked exit (I think for ofail effects?)
  def command_open(cmd)
    line = rest(cmd.line)
    directions, num = line.split('=')
    directions = directions.split(';')

    destination_uuid = namedb.num_map[num.to_i]
    if !destination_uuid && num
      puts "Error: No such room number (#{num})"
      return
    end
    destination = manager[destination_uuid]

    if Container.one_for(destination)
      room_for(cmd.entity).add Link.new(directions, destination)
    else 
      puts "You cannot open into a non-room"
      return
    end
    
    if !num
      puts "Created unlinked exit"
    else
      puts "Created exit to: #{Name.one_for(destination).value}"
    end
  end

  def command_say(cmd)
    puts "You say, '#{cmd.line}'"
  end

  def command_quit(cmd)
    exit 0
  end

  def process
    Command.all do |cmd|
      next unless /(?<command>[\S]+)/ =~ cmd.line
      method = COMMANDS[command] || COMMANDS['say']
      __send__ method, cmd
      cmd.delete
    end
  end

  def name_to_object_info(issuer, name)
    if name == "here"
      entity = manager[ContainedBy.one_for(issuer).uuid]
      name = Name.one_for(entity)
      num = namedb.name_map[name]
    elsif name =~ /^\d+$/
      num = name.to_i
      entity = manager[namedb.num_map[num]]
      name = Name.one_for(entity)
    else
      num = namedb.name_map[name]
      entity = manager[namedb.num_map[num]]
    end
    [name, num, entity]
  end
  private :name_to_object_info

  def room_for(entity)
    manager[ContainedBy.one_for(entity).uuid]
  end

  def rest(line)
    line.split(/\s+/, 2)[1]
  end
  private :rest
end
