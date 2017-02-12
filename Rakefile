$LOAD_PATH << 'lib'

require 'rus'

task :default do
  app = -> (env) {
    body = "Hello World!\n"

    [
      200,
      {
        'Content-Type' => 'text/plain',
        'Content-Length' => body.bytesize,
        'Connection' => 'close',
      },
      [body],
    ]
  }

  Rus::Server.new(app).()
end
