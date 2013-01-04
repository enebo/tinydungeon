##
# A client connection representing a player in the game.  
class PlayerConnection
  def initialize(entity, socket)
    @entity, @socket = entity, socket
    @buf = ''
    @log_out = false
  end

  def logged_out?
    @log_out
  end

  def logout
    @log_out = true
  end

  def read_input
    @buf << @socket.read_nonblock(1024)

    if @buf =~ /([^\n]+)\n/m
      command_line = $1
      entity.has Command.new(command_line)
    end
  end
end
