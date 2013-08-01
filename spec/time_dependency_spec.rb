require 'spec_helper'

describe TimeDependency do

	it "initializes" do
		t = TimeDependency.new("12:34:00")
		t.to_s.should == "T(12:34:00)"
	end

	it "clears" do
		dep = TimeDependency.new(Time.now.strftime("%H:%M:%S"))
		dep.cleared?.should be_true
	end

end


