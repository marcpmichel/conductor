module Conductor
	module JobStatus
		NONE = 0
		WAIT = 1
		EXEC = 2
		FAIL = 3
		SUCC = 4
		CNCL = 5
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

		def go?
			not(ran?) && @status != JobStatus::EXEC && @deps.all?(&:cleared?)
		end

		def ran?
			not @last_start_at.nil? 
		end

		def go!
			@pid = spawn @command #, :out => [:child, @stdout], :err => [:child, @stderr]
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
			success? || failed?
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
