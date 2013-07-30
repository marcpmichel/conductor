require 'stringio'
require 'daytime'

module Conductor

	class Runner
		class << self
			def run(presenter)
				loop do
					presenter.present
					Jobs.ready_to_start.each do |job|
						puts %Q|starting "#{job.name} (#{job.command})"|
						job.go!
					end

					break if Jobs.all.all?(&:ran?) && Jobs.running.count == 0
					puts "#{Jobs.running.count} jobs still running."
					sleep 1
				end
			end

		end
	end

end

