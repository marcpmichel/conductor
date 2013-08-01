require 'spec_helper'

describe Conductor do

	it "can add jobs given a jobdef" do
		Conductor::add_job({:name => "test job"})
		Conductor.jobs.first.name.should == "test job"
	end

	it "can find jobs by name" do
		Conductor::add_job({name: "find me!"})
		Conductor::find_job("find me!").should be_a(Job)
	end

end
