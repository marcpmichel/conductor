
require 'spec_helper'

describe Conductor do

	after :each do
		Runner.reset_jobs
	end

	it "runs jobs" do
		job = double("job")
		job.stub(:name).and_return("jobname")
		job.stub(:command).and_return("command")
		job.stub(:running?).and_return(false)
		job.stub(:ran?).and_return(true)
		job.stub(:go?).and_return(true)
		job.should_receive(:go!)
		Runner.add_job(job)
		Runner.run
	end

	it "uses the given presenter" do
		JobsTextPresenter.should_receive(:new)
		Runner.presenter_class = JobsTextPresenter
		Runner.run
	end

end
