#different testsuits exec shuffle or order
#author:wuhongliang
#date:2016-07-27
module Minitest
    @should_shuffle_suites=true
    @testsuites_all       =""
    mc                    = (
    class << self;
        self;
    end)
    mc.send :attr_accessor, :should_shuffle_suites
    mc.send :attr_accessor, :testsuites_all
    ##
    # Internal run method. Responsible for telling all Runnable
    # sub-classes to run.
    #
    def self.__run reporter, options
        suites           = should_shuffle_suites ? Runnable.runnables.shuffle : Runnable.runnables
        testsuites_all   = suites
        parallel, serial = suites.partition { |s| s.test_order == :parallel }

        # If we run the parallel tests before the serial tests, the parallel tests
        # could run in parallel with the serial tests. This would be bad because
        # the serial tests won't lock around Reporter#record. Run the serial tests
        # first, so that after they complete, the parallel tests will lock when
        # recording results.
        serial.map { |suite| suite.run reporter, options } +
            parallel.map { |suite| suite.run reporter, options }
    end

end