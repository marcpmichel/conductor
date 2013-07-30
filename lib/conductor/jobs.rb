require 'jobs'
module Conductor

	class Jobs
		class << self
			@@jobs=[]

			def add(job)
				@@jobs << job
			end

			def find_by_name(given_name)
				@@jobs.find { |job| job.name == given_name }
			end

			def running
				@@jobs.select(&:running?)
			end

			def all
				@@jobs
			end

			def first
				@@jobs.first
			end

			def ready_to_start
				@@jobs.select(&:go?)
			end

			def load(filename)
				yaml = YAML::load_file(filename)
				yaml[:jobs].each do |job|
					self.add Job.new({:name => job[:name], :desc => job[:desc], :command => job[:command], :deps => deps(job)})
				end
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
end
