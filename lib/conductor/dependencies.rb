
module Conductor
	class DependencyBuilder
		def initialize(conductor)
			@conductor = conductor
		end

		def build(dep_def)
			dep_def.strip!
			parsed = /(\w+)\((.*)\)/.match(dep_def)
			parse_error(dep_def, "syntax error") if parsed.nil? || parsed.captures.count != 2
			dep_type = parsed[1].strip
			dep_param = parsed[2].strip
			new_dep = instantiate(dep_def, dep_type, dep_param)
			@conductor.get_dependency(new_dep.name) || @conductor.add_dependency(new_dep) 
		end

		private

		def instantiate(dep_def, type, param)
			case type
				when "success" then JobDependency.new(job_ref(dep_def, param), {:ignore_fail => false} )
				when "after" then JobDependency.new(job_ref(dep_def, param), {:ignore_fail => true} )
				when "at" then TimeDependency.new(param)
				else parse_error(dep_def, "unknown dependency type")
			end
		end

		def parse_error(dep_def, message)
			raise %Q|Error while parsing dependency "#{dep_def}" : #{message}|
		end

		def job_ref(dep_def, job_name)
			@conductor.get_job(job_name) || parse_error(dep_def, %Q|can't find a job named "#{job_name}"|)
		end

	end

	class JobDependency

		def initialize(job_ref, options={})
			@job_ref = job_ref
			@options = { :ignore_fail => false }.merge(options)
		end

		def ignore_fail?
			@options[:ignore_fail] == true
		end

		def cleared?
			ignore_fail? ? @job_ref.done? : @job_ref.success?
		end

		def name
			if ignore_fail?
				"after(#{@job_ref.name})"
			else
				"success(#{@job_ref.name})"
			end	
		end
		alias to_s name

	end


	require 'daytime'

	class TimeDependency

		def initialize(time_string)
			@at = Daytime.from_string(time_string)
		end

		def cleared?
			Daytime.from_time(Time.now) > @at
		end
			
		def name
			"at(#{@at.to_s})"
		end
		alias to_s name

	end

end
