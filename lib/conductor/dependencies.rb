
module Conductor

	class JobDependency

		attr_accessor :job

		def initialize(jobname, options={:ignore_fail => false })
			@jobname = jobname
			@options = options
		end

		def cleared?
			other_job = Conductor::find_job(@jobname)
			@options[:ignore_fail] ? job.done? : job.success?
		end

		def to_s
			"J(#{@jobname.to_s})"
		end
	end


	require 'daytime'

	class TimeDependency

		attr_accessor :job

		def initialize(time_string)
			@at = Daytime.from_string(time_string)
		end

		def cleared?
			Daytime.from_time(Time.now) > @at
		end

		def to_s
			"T(#{@at.to_s})"
		end
	end

end
