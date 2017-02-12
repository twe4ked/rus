require 'socket'
require 'rus/response_builder'

module Rus
  class Server
    attr_reader :app

    def self.call(*args)
      new.call(*args)
    end

    def initialize(app)
      @app = app
    end

    def call
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

      status, headers, body = app.call({})

      response = ResponseBuilder.call(status, headers, body)
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
