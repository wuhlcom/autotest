#encoding: utf-8
file_path =File.expand_path('../../../lib/htmltags', __FILE__)
require file_path
p "002"
class TestCase002<MiniTest::Unit::TestCase
    i_suck_and_my_tests_are_order_dependent!
    # parallelize_me!
    def test_ip1
        p ip = "192.168.102.1"
        assert(true)
    end

    def test_ip2
        p ip = "192.168.102.2"
        assert(true)
    end

    def test_ip3
        p ip = "192.168.102.3"
        assert(true)
    end

    def test_ip4
        p ip = "192.168.102.4"
        assert(true)
    end
end