require 'conductor/jobs'

module Conductor

	class Conductor
		class << self
			@@jobs = Jobs.new
			@@presenter = nil

			def load(jobs_definition_filename)
				@@jobs.load(jobs_definition_filename)
			end

			def add_job(job)
				@@jobs.push(job)
			end

			def presenter=(presenter)
				@@presenter = presenter
			end

			def find_job(job_name)
				@@jobs.find_by_name(job_name)
			end

			def jobs
				@@jobs
			end

			def conduct
				loop do
					@@presenter.redraw(@@jobs) if !!@@presenter
					@@jobs.ready_to_start.each(&:go!)

					break if should_stop?

					sleep 1
				end
			end

			def reset_jobs
				@@jobs.clear
			end

			private

			def should_stop?
				@@jobs.all?(&:ran?) && @@jobs.running.count == 0
			end

		end
	end

end

