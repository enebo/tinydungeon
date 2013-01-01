
module MessageHelper
  ##
  # sender say something and all in room will hear it.
  def say(sender, msg)
    # Send to container itself so it can react
    container = container_for(sender)
    a_message = create_message(SayMessage.new(msg)).tap do |message|
      message.has Sender.new sender
    end
    container.add MessageRef.new(a_message)

    # Send to all things in the container
    each_container_entity(container) do |receiver|
      a_message = create_message(SayMessage.new(msg)).tap do |message|
        message.has Sender.new sender
      end
      receiver.add MessageRef.new(a_message)
    end
  end

  ##
  # Output a message to the intended receiver only
  def output_you(receiver, msg)
    receiver.add MessageRef.new(create_message(OutputMessage.new(msg)))
  end

  ##
  # sender output something
  def output_others(sender, msg)
    each_container_entity(container_for(sender)) do |receiver|
      if receiver != sender
        receiver.add MessageRef.new(create_message(OutputMessage.new(msg)))
      end
    end
  end

  def create_message(type)
    Wreckem::Entity.is! do |message|
      message.has type
      message.has Timestamp.new(Time.now.to_i)
    end
  end
end
