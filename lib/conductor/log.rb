
def log(message, &block)
	print "[#{Thread.current}] #{message}"

	if block_given?
		print " ..."
		yield
		print "done."
	end
	puts ""
end

