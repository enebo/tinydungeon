require 'wreckem/system'

require 'tinydungeon/components/command_line'
require 'tinydungeon/components/containee'
require 'tinydungeon/components/echo'
require 'tinydungeon/components/message'
require 'tinydungeon/components/player'

class HearThingsSystem < Wreckem::System
  def initialize(game)
    super(game)
  end

  def process
    new_messages = []
    Message.all do |message|
      receiver = message.entity
      if Player.one_for(receiver)
        puts message.line
      elsif Echo.one_for(receiver)
        new_message =  Message.new "You hear an echo, \"#{message.line}\""
        Containee.for(receiver) do |l|
          new_messages << [manager[l.uuid], new_message]
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
