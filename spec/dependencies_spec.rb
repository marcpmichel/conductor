
require 'spec_helper'

describe JobDependency do

	it "clears" do
		dep = JobDependency.new("one")
		jobdef = { name:"one", deps:[dep] }
		Conductor.add_job(jobdef) 
		job = Conductor::find_job("one")
		job.stub(:success?).and_return true
		dep.cleared?.should be_true
	end

end

describe TimeDependency do

	it "initializes" do
		t = TimeDependency.new("12:34:00")
		t.to_s.should == "T(12:34:00)"
	end

	it "clears" do
		one_minute_ago = (Time.now - 60).strftime("%H:%M:%S")
		dep = TimeDependency.new(one_minute_ago)
		dep.cleared?.should be_true
	end

end



