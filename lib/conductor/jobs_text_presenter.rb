require 'yaml'
module Conductor

	class JobTextPresenter
		class << self
			def of(job)
				JobTextPresenter.new(job)
			end

			def row_format
				"| %-20s| %-9s| %-40s|"
			end

			def header
				"\e[7m" + row_format % ["  job name", "status", "  dependencies"] + "\e[27m"
			end

			def hr
				"-" * (row_format % ["","",""]).length
			end
		end

		def row
			JobTextPresenter::row_format % [ @job.name, status, deps ]
		end

		def deps
			@job.deps.map(&:to_s).join(', ')
		end

		def status
			case @job.status
				when 0 then "\e[37m ? \e[39m   "
				when 1 then "\e[36m WAIT \e[39m   "
				when 2 then "\e[33m EXEC \e[39m   "
				when 3 then "\e[31m FAIL \e[39m   "
				when 4 then "\e[32m SUCC \e[39m   "
			end
		end

		def initialize(job)
			@job = job
		end
		private :initialize

	end

	class JobsTextPresenter
		def self.present
			puts JobTextPresenter.hr
			puts JobTextPresenter.header
			Jobs.all.each { |job| puts JobTextPresenter.of(job).row }
			puts JobTextPresenter.hr
		end
	end

end
