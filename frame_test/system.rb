testsuite {

	# Called before every ftp_test method runs. Can be used  to set up fixture information.
	def setup
	end
	# Called after every ftp_test method runs. Can be used to tear down fixture information.
	def teardown
		p __method__
	end


}