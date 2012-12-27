require 'socket'
require 'wreckem/system'

require 'tinydungeon/game_components'
require 'tinydungeon/systems/helpers/container_helper'

class AcquireCommandsSystem < Wreckem::System
  include ContainerHelper

  def initialize(game)
    super(game)
  end

  def process
    port = 9001
    @server = TCPServer.open(port)
    @fds = [@server]
    puts "Server started on port #{port}"

    while true
      if ios = select(@fds, [], [], 10)
        ready_sockets = ios.first
        ready_sockets.each do |client|
          if client == @server
            puts "CLIENT CONNECTED"
            client, _ = @server.accept
            @fds << client
            login(client)
          elsif client.eof?
            puts "CLIENT EOF'd"
            @fds.delete client
            client.close
          else
            player = game.players[client]
            if !game.connections[player]  # trying to log
              puts "Logging out..."
              @fds.delete client
              client.close
            else
              game.players[client].add CommandLine.new(client.gets("\n").chomp)
            end
          end
        end
      end
    end
  ensure
    @fds.each { |c| c.close }
  end

  def login(client)
    player = nil
    while player.nil?
      client.write("What is your name? ")
      name = client.gets("\n").chomp
      # FIXME: Whoa...huge search space
      Player.intersects(Name) do |entity, _, entity_name|
        if name == entity_name.value
          player = entity
          break;
        end
      end

      if !player
        client.write "Player name #{name} does not exist. Create it (y/n)?  "
        if client.gets("\n").chomp =~ /^y/
          player = game.create_player(name, "help @describe to set me")
        end
      else
        # FIXME: On crash lastcontained by may not exist and use contained by
        last_room = player.one(LastContainedBy)
        room = manager[last_room]
        if last_room and room
          player.delete last_room
        else
          room = game.entry
        end
        client.puts "Welcome back #{player.one(Name)}"
        add_to_container(room, player)
      end
    end
    game.connections[player] = client
    game.players[client] = player
    client.write("Connected as player #{player.one(Name)}\n\n ")

    player.add CommandLine.new("look")
  rescue
    puts "Whoops #{$!} #{caller.inspect}"
  end
end
