
module Conductor
	module JobStatus
		INTR = 0 # introduction
		WAIT = 1 # waiting ( PEND for pending ? )
		EXEC = 2 # executing
		FAIL = 3 # failed
		SUCC = 4 # success (terminated with 0 return status )
		CNCL = 5 # cancelled
		ABRT = 6 # aborted ( killed )
	end
end
