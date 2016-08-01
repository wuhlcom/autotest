#encoding: utf-8
file_path =File.expand_path('../../../lib/htmltags', __FILE__)
require file_path
p "001"

module MyMinitestPlugin
    def before_setup
        super
        # ... stuff to do before setup is run
        p @name1="bbb"
    end

    def after_setup
        # ... stuff to do after setup is run
        super
        p @name2="ccc"
    end

    def before_teardown
        super
        # ... stuff to do before teardown is run
    end

    def after_teardown
        # ... stuff to do after teardown is run
        super
    end
end

class TestCase001<MiniTest::Unit::TestCase
    i_suck_and_my_tests_are_order_dependent!
    include MyMinitestPlugin
    # parallelize_me!
    def test_ip1
        p $url
        # p url      ="wwww.baidu.com"
        # @browser.goto(url)
        # p ip = "192.168.100.1"
        # assert(true)
    end

    # def test_ip2
    #     p ip = "192.168.100.2"
    #     assert(true)
    # end
    #
    # def test_ip3
    #     p ip = "192.168.100.3"
    #     assert(true)
    # end
    #
    # def test_ip4
    #     p ip = "192.168.100.4"
    #     assert(true)
    # end

    def setup
    end

    def teardown

    end
end