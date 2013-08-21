require 'socket'      # Sockets are in standard library
require 'protocol'

#require 'readline'
#require 'rainbow'

module Conductor
	class Client

		#TODO: command-line parsing : use optionparser or GLI or thor
		def self.start
			hostname = 'localhost'
			port = 2222

			puts "connecting..."
			socket = TCPSocket.open(hostname, port)
			puts "connected."

			if handshake(socket)
				puts "handshake ok"
				loop do
					break if socket.closed?
					print "> "
					command = ARGF.gets.strip
					socket.puts command
					response = socket.gets.strip
					puts "#{response}"
					break if response == Protocol::CMD_QUIT
				end
			end

			socket.close               # Close the socket when done
		end

		private
		def handshake(socket)
			puts "handshaking..."
			welcome = socket.gets.strip
			return false if welcome != Protocol::HANDSHAKE_SERVER
			socket.puts Protocol::HANDSHAKE_CLIENT
			return true
		end
	end
end
