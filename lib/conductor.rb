require 'conductor/jobs'
require 'conductor/jobs_text_presenter'

module Conductor

	class Runner
		class << self
			@@jobs = Jobs.new
			@@presenter = nil

			def load(jobs_definition_filename)
				@@jobs.load(jobs_definition_filename)
			end

			def add_job(job)
				@@jobs.push(job)
			end

			def presenter_class=(presenter_class)
				@@presenter = presenter_class.new(@@jobs)
			end

			def jobs
				@@jobs
			end

			def run
				loop do
					@@presenter.redraw if !!@@presenter

					@@jobs.ready_to_start.each(&:go!)

					break if should_stop?

					#puts "#{Jobs.running.count} jobs still running."
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

