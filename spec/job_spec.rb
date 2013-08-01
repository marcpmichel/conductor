require 'spec_helper'

describe Job do

	before :all do
		@default_job = Job.new
	end

	it "initializes" do
		@default_job.name.should == "job name"
	end

	it "checks if all deps are cleared" do
		@default_job.all_deps_cleared?.should be_true
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

	it "create an instance from a hash" do
		jobdef = { name: "jobname", desc: "description", command: "ls", deps: [] }
		job = Job.from_hash( jobdef )
		job.name.should == "jobname"
		job.command.should == "ls"
	end

end
