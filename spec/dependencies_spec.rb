
require 'spec_helper'

describe DependencyBuilder do
	before :all do
		@conductor = Conductor::Conductor.new
	end

	it "builds a job dependency" do
		@conductor.add_job({ :name => "pouet" })
		dep = DependencyBuilder.new(@conductor).build("success(pouet)")
		dep.should be_a(JobDependency)
	end

	it "builds a time dependency" do
		dep = DependencyBuilder.new(@conductor).build("at(12:30)")
		dep.should be_a(TimeDependency)
	end

	it "vomits if there's a parsing error" do
		lambda { DependencyBuilder.new(@conductor).build("vomit, you parser !")}.should raise_error(RuntimeError)
	end
end

describe JobDependency do

	it "clears" do
		conductor = Conductor::Conductor.new
		conductor.add_job({ name: "one"})
		conductor.add_job({ name: "two", deps: "after(one)" })
		#conductor.deps.each { |dep| puts dep.inspect }
		dep = conductor.get_dependency("after(one)")
		dep.should_not be_nil
		job = conductor.get_job("one").stub(:success?).and_return(true)
		dep.cleared?.should be_true
	end

end

describe TimeDependency do

	it "initializes" do
		t = TimeDependency.new("12:34:00")
		t.to_s.should == "at(12:34:00)"
	end

	it "clears" do
		one_minute_ago = (Time.now - 60).strftime("%H:%M:%S")
		dep = TimeDependency.new(one_minute_ago)
		dep.cleared?.should be_true
	end

end



