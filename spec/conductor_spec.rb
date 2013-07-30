
require_relative '../lib/conductor'

describe Conductor do

	it "runs jobs" do
		Jobs.load("testjobs.yaml")
		#JobsTextPresenter.present
		Runner.run( JobsTextPresenter )
	end

end
