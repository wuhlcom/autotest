#encoding:utf-8
gem 'minitest'
require 'minitest/autorun'

file_path =File.expand_path('../../lib/iam', __FILE__)
require file_path
class MyTestString < MiniTest::Unit::TestCase
    # include IAMAPI::Manager
    # include IAMAPI::Oauth
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

    #手机用户注册
    def test_phone_reg
        pho= "14400004444"
        # pho = "13760281579"
        pw = "123456"
        p @iam_obj.register_phoneusr(pho, pw)
    end

    #手机用户修改密码
    def test_modpwd_mobile
        pho = "14400004444"
        # pho = "13760281579"
        pw  = "1234567"
        p @iam_obj.usr_modpw_mobile pho, pw
    end

    # Fake ftp_test
    # def test_fail
    #
    #   fail('Not implemented')
    # end

end