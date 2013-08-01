require 'spec_helper'

describe JobDependency do

	it "clears" do
		dep = JobDependency.new("one")
		Conductor::Conductor.add_job(Job.new("one","test","exit 0",[dep])) 
		dep.cleared?.should be_true
	end

end
