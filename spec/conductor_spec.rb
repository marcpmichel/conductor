require 'spec_helper'

describe Conductor do

	before :each do
		@conductor = Conductor::Conductor.new
	end

	it "can add jobs given a jobdef" do
		@conductor.add_job({:name => "test job"})
		@conductor.jobs["test job"].name.should == "test job"
	end

	it "adds dependencies from a given jobdef" do
		@conductor.add_job({:name => "job with deps", :deps => "at(12:34)"})
		# @conductor.deps.each { |dep| puts dep.inspect }
		@conductor.get_dependency("at(12:34:00)").should_not be_nil
	end

	it "can find jobs by name" do
		@conductor.add_job({name: "find me!"})
		@conductor.get_job("find me!").should be_a(Job)
	end

end
