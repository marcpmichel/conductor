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
			#self.select(&:go?)
			self.select do |job| 
				not(job.ran?) && not(job.running?) && job.all_deps_cleared?
			end 
		end

		def load(filename)
			yaml = YAML::load_file(filename)
			yaml[:jobs].each do |jobdef|
				self.push Job.new( jobdef[:name], jobdef[:desc], jobdef[:command], deps(jobdef))
			end
			self.count
		end


		private

		def deps(jobdef)
			return [] if jobdef[:deps].nil?

			jobdef[:deps].map do |dep|
				case dep[:type]
					when :job then JobDependency.new(dep[:param])
					when :time then TimeDependency.new(dep[:param])
					else raise "Unknown dependency type"
				end
			end
		end

	end
end
