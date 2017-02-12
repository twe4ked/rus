require 'socket'

module Rus
  class Server
    def self.call
      new.call
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

      app = -> (env) {
        [
          200,
          {
            'Content-Type' => 'text/plain',
          },
          ["Hello World!\n"],
        ]
      }

      status, headers, body = app.call({})

      body = format_body(body)

      headers['Content-Length'] = body.bytesize
      headers['Connection'] = 'close'

      response = [
        format_status(status),
        format_headers(headers),
        body
      ].join("\n")

      log response.chomp

      client_socket.print response

      client_socket.close
    end

    def format_status(status)
      "HTTP/1.0 #{status} OK"
    end

    def format_headers(headers)
      headers.inject('') { |acc, (k,v)| acc << "#{k}: #{v}\n" }
    end

    def format_body(body)
      acc = ''
      body.each { |v| acc << v }
      acc
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
