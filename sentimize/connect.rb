require 'rubygems'
require 'socket'
require 'psych'

module Sentimize
  class Connect 
      def initialize user, pass
        @ba = ["#{user}:#{pass}"].pack('m').chomp
      end

      def listen listener
        socket = TCPSocket.new 'stream.twitter.com', 80
        socket.write "GET /1/statuses/sample.json HTTP/1.1\r\n"
        socket.write "Host: stream.twitter.com\r\n"
        socket.write "Authorization: Basic #{@ba}\r\n"
        socket.write "\r\n"

        # Read the headers
        while((line = socket.readline) != "\r\n"); puts line if $DEBUG; end

        reader, writer = IO.pipe
        producer = Thread.new(socket, writer) do |s, io|
          loop do
            io.write "---\n"
            io.write s.read s.readline.strip.to_i 16
            io.write "...\n"
            s.read 2 # strip the blank line
          end
        end

        parser = Psych::Parser.new listener
        parser.parse reader

        producer.join
      end
    end

    class Listener < Psych::Handler
      def initialize
        @was_text = false
      end

      def scalar value, anchor, tag, plain, quoted, style
        puts value if @was_text
        @was_text = value == 'text'
      end
    end
  end
  
  StreamClient.new(ARGV[0], ARGV[1]).listen Listener.new
