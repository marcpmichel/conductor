require 'spec_helper'

describe TextPresenter do
	
	before :all do
		@presenter = TextPresenter.new
		@job = Job.new("test job")
	end

	it "has a header" do
		@presenter.header.should match /.*job name.*status.*dependencies.*/
	end

	it "presents the status of a job" do
		@job.stub(:status).and_return JobStatus::EXEC
		@presenter.status(@job).should include("EXEC")
	end

	it "presents a job" do
		@presenter.row(@job).should match /.*test job.*/
	end
end
