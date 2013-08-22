
require 'conductor/dependencies'
require 'conductor/job'

module Conductor
	
	class Conductor

		attr_reader :jobs
		attr_reader :deps

		def initialize
			@jobs = {}
			@deps = {}
		end
=begin
		def load(jobs_definition_filename)
			yaml = YAML::load_file(filename)
			yaml[:jobs].each do |jobdef|
				self.push Job.from_hash(jobdef)
			end
			self.count
		end
=end

		def add_job(job_def)
			job = JobBuilder.new(self).build(job_def)
			raise "Error : job with name #{job.name} already exists" if @jobs.has_key?(job.name)
			@jobs[job.name] = job
		end

		def get_job(name)
			@jobs[name]
		end

		def add_dependency(dep)
			@deps[dep.name] = dep
		end
		
		def get_dependency(name)
			@deps[name]
		end

		def dependencies(dep_defs)
			@deps.values_at(dep_defs)
		end

=begin
		# create dependencies if they don't exist
		def add_dependencies(dep_defs)
			dep_defs.each do |dep|
				@deps[dep] = DependencyParser::parse(dep, @jobs) unless @deps.has_key?(dep)
			end
		end

		def find_job(name)
			@jobs[name]
		end
=end

		def conduct
			LOG.info("Starting to conduct...")
			loop do
				@jobs.values.select(&:go?).each(&:go!)

				break if should_stop?

				sleep 1
			end
			LOG.info("All jobs done.")
		end

		def reset
			@jobs.clear
			@deps.clear
			LOG.info "jobs and deps were resetted"
		end

		private

		def should_stop?
			@jobs.values.all?(&:ran?) && @jobs.values.none?(&:running?)
		end

	end

end
