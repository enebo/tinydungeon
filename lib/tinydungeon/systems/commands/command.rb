require 'tinydungeon/game_components'
require 'tinydungeon/systems/helpers/container_helper'
require 'tinydungeon/systems/helpers/link_helper'
require 'tinydungeon/systems/helpers/message_helper'
require 'tinydungeon/systems/helpers/name_helper'

class Command
  include ContainerHelper, LinkHelper, MessageHelper, NameHelper
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
#{description}

Usage: #{usage}
EOS
  end

  def game
    system.game
  end

  def manager
    system.manager
  end

  def rest(cmd)
    cmd.value.split(/\s+/, 2)[1]
  end

  def name
    '/' + self.class.name.downcase.split(/command$/)[0]
  end

  def aliases
    []
  end

  def self.register(command_system)
    command = new(command_system)
    command_system.commands[command.name] = command
    command.aliases.each { |a| command_system.aliases[a] = command }
  end
end
