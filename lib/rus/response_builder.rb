module Rus
  class ResponseBuilder
    def self.call(*args)
      new.call(*args)
    end

    def call(status, headers, body)
      body = format_body(body)

      [
        format_status(status),
        format_headers(headers),
        body
      ].join("\n")
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
  end
end
