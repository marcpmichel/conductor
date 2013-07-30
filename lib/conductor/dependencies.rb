
module Conductor

	class Dependency
		def cleared?
			raise "base class"
		end
		def to_s
			raise "base class"
		end
	end

	class TimeDependency < Dependency
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

	class DelayDependency < Dependency
		def initialize(delay_in_seconds)
			@delay = delay_in_seconds
			@dep = TimeDependency.new((Time.now + delay_in_seconds).strftime("%H:%M:%S"))
		end
		def cleared?
			@dep.cleared?
		end
		def to_s
			"D(#{@delay}s)"
		end
	end

	class JobDependency < Dependency
		def initialize(jobname, options={:ignore_fail => false })
			@jobname = jobname
			@options = options
		end
		def cleared?
			job = Jobs::find_by_name(@jobname)
			@options[:ignore_fail] ? job.done? : job.success?
		end
		def to_s
			"J(#{@jobname.to_s})"
		end
	end
end
