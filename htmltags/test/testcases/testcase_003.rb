#encoding: utf-8
file_path =File.expand_path('../../../lib/htmltags', __FILE__)
require file_path
p "003"
class TestCase003<MiniTest::Unit::TestCase
    i_suck_and_my_tests_are_order_dependent!
    # parallelize_me!
    def test_ip1
        p ip = "192.168.103.1"
        assert(true)
    end

    def test_ip2
        p ip = "192.168.103.2"
        assert(true)
    end

    def test_ip3
        p ip = "192.168.103.3"
        assert(true)
    end

    def test_ip4
        p ip = "192.168.103.4"
        assert(true)
    end
end