
require 'socket'               # Get sockets from stdlib
require 'conductor/log'
require 'conductor/session'

module Conductor

	class Server
		def self.start
			port = 2222

			puts "creating conductor instance"
			conductor = Conductor.new

			puts "starting conductor server on port #{port}"
			Thread.abort_on_exception = true
			Socket.tcp_server_loop(2222) do |socket, addrinfo|
				Session.create(socket, conductor)
			end
		end
	end

end

