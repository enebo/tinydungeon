require 'wreckem/system'

require 'tinydungeon/game_components'
require 'tinydungeon/systems/helpers/container_helper'
require 'tinydungeon/systems/helpers/link_helper'

class HearThingsSystem < Wreckem::System
  include ContainerHelper, LinkHelper, MessageHelper

  def initialize(game, commands)
    super(game)
    @commands = commands
  end

  def process
    new_messages = []

    MessageRef.all do |message_ref|
      receiver = message_ref.entity
      receiver.delete message_ref
      message = manager[message_ref]

      if receiver.is?(Player)
        msg = message.one(OutputMessage)
        if !msg
          msg = message.one(SayMessage)
          if msg
            sender = manager[message.one(Sender)]
            msg = sender == receiver ? 
              "You say, '#{msg}'." : "#{sender.one(Name)} says, '#{msg}'."
          end
        end

        game.connections[receiver].puts msg if msg
      end
      
      if receiver.is?(NPC)
        room = container_for(receiver)

        msg = message.one(SayMessage)
        if msg
          link = link_for(room, msg)
          if link
            CommandLine.new("/goto #{link.one(Name)}").tap do |cl|
              receiver.add cl
              @commands['/goto'].execute(cl)
              receiver.delete cl
            end
            process
          end
        end
      end

      if receiver.has?(Echo) && msg = message.one(SayMessage)
        output_others(receiver, "You hear an echo, \"#{msg}\"")
      end

      message.delete
    end
  end
end
