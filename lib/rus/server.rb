require 'socket'

module Rus
  class Server
    def self.run
      new.run
    end

    def run
      Signal.trap('INT') do
        socket.close
        puts
        exit 130
      end

      log 'Running on http://localhost:4242'

      loop do
        accept
      end
    end

    private

    def accept
      client_socket, client_addrinfo = socket.accept
      request = client_socket.recv 1056

      log
      log request

      data = "Hello World!\n"

      response = <<-EOF
HTTP/1.0 200 OK
Content-Type: text/plain
Content-Length: #{data.bytesize}
Connection: close

#{data}
      EOF

      log response.chomp

      client_socket.print response

      client_socket.close
    end

    def socket
      @socket ||= begin
        socket = Socket.new :INET, :STREAM, 0
        socket_addrinfo = Addrinfo.tcp '127.0.0.1', 4242
        socket.bind socket_addrinfo
        socket.listen 5
        socket
      end
    end

    def log(string = nil)
      puts string
    end
  end
end
