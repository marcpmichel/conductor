require 'conductor/job_status'

module Conductor

	class JobBuilder

		def initialize(conductor)
			@conductor = conductor
		end

		def build(jobdef)
			jobdef = { name:"undefined", desc: "", command: "exit 1", deps: "" }.merge(jobdef)
			Job.new( jobdef[:name], jobdef[:desc], jobdef[:command], dependencies(jobdef[:deps]) )
		end

		private

		def dependencies(dep_defs)
		 dependencies_definitions(dep_defs).map do |dep_def|
			DependencyBuilder.new(@conductor).build(dep_def)
		 end
		end

		def dependencies_definitions(dep_defs)
				return [] if dep_defs.nil?
				dep_defs.split(',').map(&:strip)
		end

	end

	class Job
		attr_reader :name, :desc, :deps, :command, :pid

		def initialize(name="job name", desc="description", command="echo hello", deps=[])
			@name = name
			@desc = desc
			@deps = Array(deps)
			@command = command
			@status = JobStatus::WAIT
			@pid = -1
			@last_start_at = nil
			# @stdout = IO.new
			# @stderr = IO.new
		end

		def all_deps_cleared?
			@deps.all?(&:cleared?)
		end
	
		def go?
			not(ran?) && not(running?) && all_deps_cleared?
		end

		def ran?
			not @last_start_at.nil? 
		end

		def go!
			@pid = Process::spawn @command #, :out => [:child, @stdout], :err => [:child, @stderr]
			@status = JobStatus::EXEC
			@last_start_at = Time.now
		end

		def status
			return @status unless @status == JobStatus::EXEC
			return @status if process_status.nil?
			@status = process_status.success? ? JobStatus::SUCC : JobStatus::FAIL
		end

		def process_status
			@process_status_memo ||= Process::wait2(@pid, Process::WNOHANG).at(1) rescue nil
		end
		private :process_status

		def done?
			success? || failed
		end

		def success?
			status == JobStatus::SUCC 
		end

		def failed?
			status == JobStatus::FAIL
		end

		def running?
			status == JobStatus::EXEC
		end
		
	end

end
