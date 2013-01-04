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
    rds = [@server]
    puts "Server started on port #{port}"

    while true
      if ios = select(rds, [], [], 10)
        read_sockets = ios.first
        read_sockets.each do |client|
          if client == @server
            puts "CLIENT CONNECTED"
            client, _ = @server.accept
            rds << client
            login(client)
          elsif client.eof?
            puts "CLIENT EOF'd"
            rds.delete client
            client.close
          else
            player = game.players[client]
            if player.logged_out?
              rds.delete client
              game.players.delete client
            else
              player.process_input
            end
          end
        end
      end
    end
  ensure
    rds.each { |c| c.close }
  end

  def login(client)
    player = nil
    while player.nil?
      client.write("What is your name? ")
      name = client.gets("\n").chomp
      # FIXME: Whoa...huge search space
      Player.intersects(Name) do |_, entity_name|
        if entity_name.same?(name)
          player = entity_name.entity
          break;
        end
      end

      if !player
        client.write "Player name #{name} does not exist. Create it (y/n)?  "
        if client.gets("\n").chomp =~ /^y/
          player = game.create_player(name, "help @describe to set me")
        end
      else
        room = Wreckem::Entity.find(player.one(BindRoom))
        room = game.entry unless room
        client.puts "Welcome back #{player.one(Name)}"
        add_to_container(room, player)
      end
      player.is(Online)
    end
    player_connection = PlayerConnection.new(player, client)
    game.connections[player.id] = player_connection
    game.players[client] = player_connection
    client.write("Connected as player #{player.one(Name)}\n\n ")

    player.add CommandLine.new("/look")
  rescue
    puts "Whoops #{$!} #{caller.inspect}"
  end
end
