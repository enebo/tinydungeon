require 'wreckem/system'

require 'tinydungeon/game_components'
require 'tinydungeon/systems/helpers/link_helper'

class HearThingsSystem < Wreckem::System
  include LinkHelper

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
        room = manager[receiver.one(ContainedBy).value]
        game.connections[receiver].puts message.line if room == where
      end

      if receiver.is?(NPC)
        room = manager[receiver.one(ContainedBy).value]

        if room == where && link_for(room, message.line)
          CommandLine.new("goto #{message.line}").tap do |cl|
            receiver.add cl
            @commands['goto'].execute(cl)
            receiver.delete cl
          end
          process
        end
      end
      if receiver.has?(Echo)
        echo_string = "You hear an echo, \"#{message.line}\""
        Containee.for(receiver) do |l|
          new_messages << [manager[l.value], Message.new(receiver, echo_string)]
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
end
