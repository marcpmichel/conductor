
require 'spec_helper'

describe Dependencies do
	it "parses one dependency" do
		deps = Dependencies.parse_dep("success(pouet)")
		deps.should be_a(JobDependency)
	end

	it "parses multiple dependencies" do
		deps = Dependencies.parse("at(13_37), after(math)")
		deps.count.should == 2
		deps.first.should be_a(TimeDependency)
	end

	it "vomits if there's a parsing error" do
		lambda { Dependencies.parse("vomit, you parser !")}.should raise_error(RuntimeError)
	end
end

describe JobDependency do

	it "clears" do
		dep = JobDependency.new("one")
		jobdef = { name:"one", deps:"after(one)" }
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



