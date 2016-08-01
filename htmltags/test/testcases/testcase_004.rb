#encoding: utf-8
file_path =File.expand_path('../../../lib/htmltags', __FILE__)
require file_path
p "004"
class TestCase004<MiniTest::Unit::TestCase
    i_suck_and_my_tests_are_order_dependent!
    # parallelize_me!
    def test_ip1
        p ip = "192.168.104.1"
        assert(true)
    end

    def test_ip2
        p ip = "192.168.104.2"
        assert(true)
    end

    def test_ip3
        p ip = "192.168.104.3"
        assert(true)
    end

    def test_ip4
        p ip = "192.168.104.4"
        assert(true)
    end
end