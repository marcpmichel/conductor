require 'conductor/job'
require 'conductor/dependencies'

module Conductor

	class Jobs < Array

		def find_by_name(given_name)
			self.find { |job| job.name == given_name }
		end

		def running
			self.select(&:running?)
		end

		def all
			self
		end

		def ready_to_start
			self.select(&:go?)
		end

		def load(filename)
			yaml = YAML::load_file(filename)
			yaml[:jobs].each do |job|
				self.push Job.new({:name => job[:name], :desc => job[:desc], :command => job[:command], :deps => deps(job)})
			end
			#puts "added #{@@jobs.count} jobs"
			self.count
		end

		def deps(job)
			return [] if job[:deps].nil?

			job[:deps].map do |dep|
				case dep[:type]
					when :delay then DelayDependency.new(dep[:param])
					when :job then JobDependency.new(dep[:param])
					else raise "Unknown dependency type"
				end
			end
		end
		private :deps

	end
end
