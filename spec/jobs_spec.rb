require 'spec_helper'

describe Jobs do

	before :all do
		@test_filepath = File.join( File.dirname(__FILE__), "testjobs.yaml")
	end

	it "can add jobs" do
		jobs = Jobs.new
		jobs.push( Job.new )
		jobs.count.should == 1
	end

	it "find a job by name" do
		jobs = Jobs.new
		test_job = Job.new("abcd")
		jobs.push test_job 
		jobs.find_by_name("abcd").should == test_job
	end

	it "find running jobs" do
		jobs = Jobs.new
		test_job = Job.new("abcd")
		test_job.stub(:running?).and_return true
		jobs.push test_job
		jobs.running.should == [ test_job ]
	end

	it "finds jobs which are ready to start" do
		jobs = Jobs.new
		test_job = Job.new("abcd")
		test_job.stub(:go?).and_return true
		jobs.push test_job
		jobs.ready_to_start.should == [ test_job ]
	end

	it "loads jobs from a yaml file" do
		jobs = Jobs.new
		jobs.load( @test_filepath ).should == 7
	end
end
