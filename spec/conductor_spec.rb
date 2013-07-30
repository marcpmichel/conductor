
require 'spec_helper'

describe Conductor do

	xit "runs jobs" do
		Jobs.load("testjobs.yaml")
		#JobsTextPresenter.present
		Runner.run( JobsTextPresenter )
	end

end
