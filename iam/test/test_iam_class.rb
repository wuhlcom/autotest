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

    def test_manager_add
        account = "zhilukeji1zhilukeji1@zhilutec.com"
        nickname= "whltest2"
        passwd  = "whltest2"
        p @iam_obj.manager_add(account, nickname, passwd)
#"{\"result\":1,\"msg\":\"\\u6dfb\\u52a0\\u6210\\u529f\"}"
# "{\"err_code\":\"5006\",\"err_msg\":\"\\u5e10\\u53f7\\u5df2\\u5b58\\u5728\",\"err_desc\":\"E_ACCOUNT_EXISTS_ERROR\"}"
    end


    # Fake ftp_test
    # def test_fail
    #
    #   fail('Not implemented')
    # end

end