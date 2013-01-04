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
    @socket.puts "Good bye"
    @socket.close
  end

  def process_input
    @buf << @socket.read_nonblock(1024)

    if @buf =~ /\n/m
      command_line, @buf = @buf.split(/\r?\n/, 2)
      @entity.has CommandLine.new(command_line)
    end
  rescue
    puts "UOH: #{$!}"
  end

  def send_output(msg)
    @socket.puts msg
  end
end
