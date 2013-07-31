require 'spec_helper'

describe Job do

	before :all do
		@default_job = Job.new
	end

	it "initializes" do
		@default_job.name.should == "job name"
	end

	it "checks if it is ready to go" do
		@default_job.go?.should be_true
	end

	it "check if it has ran" do
		@default_job.ran?.should be_false
	end

	it "spawn a process" do
		Process.stub(:spawn).and_return 123
		job = Job.new( "name", "desc", "sleep 123", [] )
		job.go!
		job.pid.should == 123
		job.running?.should == true
		Process.unstub(:spawn)
	end

end
