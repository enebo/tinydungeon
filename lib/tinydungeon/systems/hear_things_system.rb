require 'wreckem/system'

require 'tinydungeon/game_components'

class HearThingsSystem < Wreckem::System
  def initialize(game, commands)
    super(game)
    @commands = commands
  end

  def process
    new_messages = []
    Message.all do |message|
      receiver = message.entity
      where = manager[message.location]

      if receiver.is?(Player)
        room = manager[receiver.one(ContainedBy).uuid]
        game.connections[receiver].puts message.line if room == where
      end

      if receiver.is?(NPC)
        room = manager[receiver.one(ContainedBy).uuid]

        if room == where && directions_for(room)[message.line]
          cl = CommandLine.new("goto #{message.line}")
          receiver.add cl
          @commands['goto'].execute(cl)
          receiver.delete cl
          process
        end
      end
      if receiver.has?(Echo)
        echo_string = "You hear an echo, \"#{message.line}\""
        Containee.for(receiver) do |l|
          new_messages << [manager[l.uuid], Message.new(receiver, echo_string)]
        end
      end
      receiver.delete message
    end

    unless new_messages.empty?
      new_messages.each do |entity, message|
        entity.add message
      end
      process
    end
  end

  def directions_for(room)
    Link.for(room).inject({}) do |directions, link|
      directions[link.directions[0]] = link.destination
      directions
    end
  end
end
