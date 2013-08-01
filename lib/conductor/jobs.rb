require 'conductor/job'
require 'conductor/dependencies'

module Conductor

	class Jobs < Array

		def find_by_name(name)
			self.find { |job| job.name == name }
		end

		def running
			self.select(&:running?)
		end

		def all
			self
		end

		def ready_to_start
			self.select(&:go?)
			# self.select do |job| 
			# 	not(job.ran?) && not(job.running?) && job.all_deps_cleared?
			# end 
		end

		def load(filename)
			yaml = YAML::load_file(filename)
			yaml[:jobs].each do |jobdef|
				self.push Job.from_hash(jobdef)
			end
			self.count
		end

	end
end
