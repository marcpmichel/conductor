
module Conductor

	class Dependencies
		class  << self
			
			def parse(deps)
				deps.split(',').map do |dep|
					parse_dep(dep)
				end
			end

			def parse_dep(dep)
				parsed = /(\w+)\((.*)\)/.match(dep.strip)
				parse_error(dep, "syntax error") if parsed.nil? || parsed.captures.count != 2
				case parsed[1]
					when "success" then JobDependency.new(parsed[2])
					when "after" then JobDependency.new(parsed[2])
					when "at" then TimeDependency.new(parsed[2])
					else parse_error(dep, "unknown dependency type")
				end
			end

			def parse_error(dep, message)
				raise %Q|Error while parsing dependency "#{dep}" : #{message}|
			end

		end
	end

	class JobDependency

		def initialize(jobname, options={:ignore_fail => false })
			@jobname = jobname
			@options = options
		end

		def cleared?
			other_job = Conductor::find_job(@jobname)
			@options[:ignore_fail] ? other_job.done? : other_job.success?
		end

		def to_s
			"J(#{@jobname.to_s})"
		end
	end


	require 'daytime'

	class TimeDependency

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
