require_relative './log'
require_relative './protocol'

class Session

	def self.create(socket)
		Thread.new(socket) do |socket|
			begin
				log "=== session start"
				Session.new(socket).start
			ensure
				socket.close
				log "=== session end"
			end
		end
	end

	def initialize(socket)
		@socket = socket
	end

	def start
		log "starting"
		raise "handshake failed" unless handshake

		loop do
			when_command_received do |command, params|
				log "got #{command} with params: #{params.join(' ')}"

				case command
					when Protocol::CMD_SHOW then show
					when Protocol::CMD_QUIT then quit("bye")
					when Protocol::CMD_SAY then say(params)
					else respond Protocol::ERR_UNKNOWN_COMMAND
				end

			end

			break if @quit_now || @socket.closed?
		end
		log "session terminated."
	end

	private

	def show
		#respond @presenter.present(Conductor::jobs)
	end

	def respond(response)
		# @socket.send response, 0
		@socket.puts response
	end

	def listen
		# @socket.recv(4096).strip
		@socket.gets.strip
	end

	def when_command_received(&block)
		command_line = listen
		command, *params = command_line.split(' ')
		raise "when_command_received need a block" unless block_given?
		yield( command, params)
	end

	def handshake
		log("sending welcome") { respond Protocol::HANDSHAKE_SERVER }
		response = ""
		log("waiting for answer") { response = listen }
		response == Protocol::HANDSHAKE_CLIENT
	end

	def quit(message)
		respond message
		@quit_now = true
	end

	def say(params)
		respond params.join(" ")
	end

end

