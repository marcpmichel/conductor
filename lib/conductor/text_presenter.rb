require 'yaml'
module Conductor

	class TextPresenter

		def present(jobs)
			puts to_s(jobs)
		end

		def to_s(jobs)
			"#{hr}\n#{header}\n#{hr}\n#{rows(jobs)}\n#{hr}\n"
		end

		def rows(jobs)
			jobs.map { |job| row(job) }.join('\n')
		end

		def row_format
			"| %-20s| %-9s| %-40s|"
		end

		def header
			#"\e[7m" + row_format % ["  job name", "status", "  dependencies"] + "\e[27m"
			row_format % ["  job name", "status", "  dependencies"]
		end

		def hr
			"-" * (row_format % ["","",""]).length
		end

		def row(job)
			row_format % [ job.name, status(job), deps(job) ]
		end

		def status(job)
			case job.status
				when 0 then "\e[37m ? \e[39m   "
				when 1 then "\e[36m WAIT \e[39m   "
				when 2 then "\e[33m EXEC \e[39m   "
				when 3 then "\e[31m FAIL \e[39m   "
				when 4 then "\e[32m SUCC \e[39m   "
				else "\e[34 ?? \e[39m   "
			end
		end

		def deps(job)
			job.deps.map(&:to_s).join(', ')
		end

	end
end
