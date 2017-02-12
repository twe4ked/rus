$LOAD_PATH << 'lib'

require 'rus'

task :default do
  app = -> (env) {
    [
      200,
      {
        'Content-Type' => 'text/plain',
      },
      ["Hello World!\n"],
    ]
  }

  Rus::Server.new(app).()
end
