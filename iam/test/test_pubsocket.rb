#encoding:utf-8
gem 'minitest'
require 'minitest/autorun'
file_path =File.expand_path('../../lib/iam', __FILE__)
require file_path
class MyTestString < MiniTest::Unit::TestCase
    # Called before every ftp_test method runs. Can be used
    # to set up fixture information.
    def setup
        @iam_obj = IAMAPI::IAM.new
        # Do nothing
    end

    # Called after every ftp_test method runs. Can be used to tear
    # down fixture information.

    def teardown
        # Do nothing
    end

    def test_del
        url = "http://192.168.10.9:8082/apps?id=160517254512&admin_id=1&token=125e0d6b0cf379e4d51fbf47bdd9598c"
        p @iam_obj.http_del(url)
    end

    def test_post
        # curl -X POST http://192.168.10.9:8082/mobileCode/18676710461
        url  = "http://192.168.10.9:8082/mobileCode/13544042762"
        data = ""
        p @iam_obj.post_data(url, data)
    end

    def test_phone_code
        phone = "13766668888"
        # phone = "18899856781"
        p @iam_obj.request_mobile_code(phone)
        p @iam_obj.get_mobile_code(phone)
    end


    # Fake ftp_test
    # def test_fail
    #
    #   fail('Not implemented')
    # end

end