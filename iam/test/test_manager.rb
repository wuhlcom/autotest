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

    def test_admin
        manager_url = "http://192.168.10.9:8082/admins/dologin"
        pp rs = @iam_obj.manager_login(manager_url) #管理员登录->得到uid和token
        assert_equal("admin@zhilutec.com", rs["name"], "manager name error!")
    end


    def test_app
        manager_url = "http://192.168.10.9:8082/admins/dologin"
        rs          = @iam_obj.manager_login(manager_url) #管理员登录->得到uid和token
        # {"result"=>1, "name"=>"admin@zhilutec.com", "nickname"=>"\u77E5\u8DEF\u7BA1\u7406\u5458", "uid"=>"1", "role_code"=>"1", "token"=>"c7dd9954c18fdbcb65e9fb35638e9025"}
        app_url     = "http://192.168.10.9:8082/apps?"
        rs["nickname"].encode("GBK")
        appname = "IAMAPI_IAM_F_OAuth_019"
        args    = {"type" => "name", "cond" => "IAMAPI_IAM_F_OAuth_019"}
        p rs_app = @iam_obj.get_spec_app_info(rs["token"], appname, app_url, rs["uid"]) #获取指定应用ID和密钥->输入uid和token，得到secret和client_id
    end

    def test_userid
        manager_url = "http://192.168.10.9:8082/admins/dologin"
        rs          = @iam_obj.manager_login(manager_url) #管理员登录->得到uid和token
        # {"result"=>1, "name"=>"admin@zhilutec.com", "nickname"=>"\u77E5\u8DEF\u7BA1\u7406\u5458", "uid"=>"1", "role_code"=>"1", "token"=>"c7dd9954c18fdbcb65e9fb35638e9025"}
        app_url     = "http://192.168.10.9:8082/apps?"
        rs["nickname"].encode("GBK")
        appname = "IAMAPI_IAM_F_OAuth_019"
        args    = {"type" => "name", "cond" => "IAMAPI_IAM_F_OAuth_019"}
        rs_app  = @iam_obj.get_spec_app_info(rs["token"], appname, app_url, rs["uid"]) #获取指定应用ID和密钥->输入uid和token，得到secret和client_id

        oauth_url   = "http://192.168.10.9:8082/index.php/Oauth/authorize"
        username    = "13760281579" #注册用户名
        encrypt_pwd = "9c76736d8a993299e155c797861d14ef7cd3507c900527e11da5d3357872ba9fb9e2db9511fe2bfafe7a6d4c6f8efdac40425414639e4815069c380c86ef4a7dd121e7db0418919a3ca8de77d745269ad19ea117154411df35f840eb1af5e82383c2d6dc627b3654f15596959e1643707995e9ef3db2847c0ca60de50ac43fc0" #用户密码
        client_id   = rs_app["client_id"]
        secret      = rs_app["client_secret"]
        # print user_login(oauth_url, username, encrypt_pwd, secret, clientid) #用户oauth登录
        p @iam_obj.user_oauth(username, encrypt_pwd, secret, client_id, oauth_url) ##用户oauth登录,输入secret和client_id得到用户的userid
        check_url = "http://192.168.10.9:8082/userid.txt"
        # get_userid(check_url) #获取userid
    end


    def test_oauth_userid
        p @iam_obj.oauth_get_userid
    end

    def test_code_error
        p @iam_obj.oauth_get_code("cod")
    end

    def test_code
        @iam_obj.oauth_get_code("code")
    end

    def test_get_usr_all
        pp @iam_obj.get_mlist_all
    end

    def test_get_usr_list_byname
        print @iam_obj.get_mlist_byname("whltest2@zhilutec.com")
    end

    def test_del_manager
        name  = " sysManager017@zhilutec.com "
        # @tc_nickname      = "autotest_whl"
        # @tc_passwd        = "123456"
        # name="whltest2@zhilutec.com"
        # p @iam_obj.get_mlist_byname(name)
        # Net::HTTP.get(url) # => String
        rs    =@iam_obj.manager_login
        token = rs["token"]
        url   = "http://192.168.10.9:8082/index.php/admins/index/uid/1/name/#{name}/token/#{token}"
        p rs = Net::HTTP.get("http://192.168.10.9", "/index.php/admins/index/uid/1/name/#{name}/token/#{token}", port="8082")
        # JSON.parse(rs)
        # p @iam_obj.del_manager(name)
        # p @iam_obj.get_mlist_byname(name)
    end

    def test_manager_add
        pho     = "13444444445"
        # account = "zhilukeji1zhilukeji@zhilutec.com"
        nickname= "autotest"
        passwd  = "123456"
        print @iam_obj.manager_add(pho, nickname, passwd)
#"{\"result\":1,\"msg\":\"\\u6dfb\\u52a0\\u6210\\u529f\"}"
# "{\"err_code\":\"5006\",\"err_msg\":\"\\u5e10\\u53f7\\u5df2\\u5b58\\u5728\",\"err_desc\":\"E_ACCOUNT_EXISTS_ERROR\"}"
    end

    def test_unicode
        str = "http://192.168.10.9:8082/index.php/admins/index/uid/1/name/\u{ff3a}\u{ff28}\u{ff29}\u{ff2c}\u{ff35}@zhilutec.com/token/17568093edf718b7d484390b81599cba"
        p @iam_obj.http_get(str)
    end


    def test_manager_add_err
        str           = "ＺＨＩＬＵ".encode("utf-8")
        @tc_man_name1 = "#{str}@zhilutec.com"
        @tc_nickname  = "autotest_whl"
        @tc_passwd    = "123456"
        puts "添加超级管理员账户为:#{@tc_man_name1}".to_gbk
        print rs = @iam_obj.manager_add(@tc_man_name1, @tc_nickname, @tc_passwd)
        # {"err_code":"5003","err_msg":"\u5e10\u53f7\u683c\u5f0f\u9519\u8bef","err_desc":"E_ACCOUNT_FORMAT_ERROR"}
        puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
        puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
        puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
        # assert_equal(rs["err_code"], @ts_err_accformat_code, "添加超级管理员#{@tc_man_name1}失败!")
        # assert_equal(rs["err_msg"], @ts_accformat_err, "添加超级管理员#{@tc_man_name1}失败!")
        # assert_equal(rs["err_desc"], @ts_accformat_err_dsc, "添加超级管理员#{@tc_man_name1}失败!")
    end

    def test_http_get
        p @iam_obj.http_get("http://192.168.10.9:8082/userid.txt")
    end

    def test_mobile_manager_modpw()
        phone    = "18900001111"
        mod_pw   = "123456222"
        nickname = "123456"
        p @iam_obj.mobile_manager_modpw(phone, mod_pw, nickname)
    end

    def test_mobile_modpw
        request_mobile_code(phone)
    end
    # Fake ftp_test
    # def test_fail
    #
    #   fail('Not implemented')
    # end

end