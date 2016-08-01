#encoding:utf-8
#override the MiniTest::Unit::TestCase initialize method
#wuhongliang
require 'iam'
require 'rexml/document'
class IamTestNameSpace<MiniTest::Unit::TestCase
    extend IAMAPI::IamFrame
    include IAMAPI::Reporter

    def initialize name
        super name
        #############################wuhongliang############################
        @iam_obj         =IAMAPI::IAM.new
        #http get
        #get userid
        @ts_url_userid   ="http://192.168.10.9:8082/userid.txt"
        #get code
        @ts_url_usercode ="http://192.168.10.9:8082/code.txt"
        #manager add
        @ts_add_rs       = 1
        @ts_add_msg      = "添加成功"

        @ts_err_accformat            = "帐号格式错误"
        @ts_err_accformat_code       = "5003"
        @ts_err_accformat_desc       = "E_ACCOUNT_FORMAT_ERROR"

        # {"err_code" => "5006", "err_msg" => "\u5E10\u53F7\u5DF2\u5B58\u5728", "err_desc" => "E_ACCOUNT_EXISTS_ERROR"}
        @ts_err_acc_exists           = "帐号已存在"
        @ts_err_acc_exists_code      = "5006"
        @ts_err_acc_exists_desc      = "E_ACCOUNT_EXISTS_ERROR"
        # {"err_code"=>"5004", "err_msg"=>"\u6635\u79F0\u683C\u5F0F\u9519\u8BEF", "err_desc"=>"E_NICKNAME_FORMAT_ERROR"}
        @ts_err_nickformat           = "昵称格式错误"
        @ts_err_nickformat_code      = "5004"
        @ts_err_nickformat_desc      = "E_NICKNAME_FORMAT_ERROR"

        # {"err_code"=>"21006", "err_msg"=>"\u89D2\u8272id\u9519\u8BEF", "err_desc"=>"E_ROLE_ERROR"}
        @ts_err_roleid               = "角色id错误"
        @ts_err_roleid_code          = "21006"
        @ts_err_roleid_desc          = "E_ROLE_ERROR"
        # {"err_code" => "5005", "err_msg" => "\u5BC6\u7801\u683C\u5F0F\u9519\u8BEF", "err_desc" => "E_PASSWD_FORMAT_ERROR"}
        @ts_err_pwformat             = "密码格式错误"
        @ts_err_pwformat_code        = "5005"
        @ts_err_pwformat_desc        = "E_PASSWD_FORMAT_ERROR"
        # {"result":1,"name":"admin@zhilutec.com","nickname":"\u77e5\u8def\u7ba1\u7406\u5458","uid":"1","role_code":"1","token":"e4f0326fa441186b18dcd66dc4509466"}
        @ts_login_url                = "http://192.168.10.9:8082/admins/dologin"
        @ts_admin_log_rs             = 1
        @ts_admin_log_name           = "admin@zhilutec.com"
        @ts_admin_log_nickname       = "知路管理员"
        @ts_admin_log_uid            = "1"
        @ts_admin_rcode              = "1"
        # {"err_code"=>"10001", "err_msg"=>"\u5E10\u53F7\u6216\u5BC6\u7801\u9519\u8BEF", "err_desc"=>"E_USER_PWD_ERROR"}
        @ts_err_login                = "帐号或密码错误"
        @ts_err_login_code           = "10001"
        @ts_err_login_desc           = "E_USER_PWD_ERROR"
        # {"err_code"=>"9002", "err_msg"=>"\u624B\u673A\u9A8C\u8BC1\u7801\u53D1\u9001\u5931\u8D25", "err_desc"=>"E_MOBILE_CODE_SEND_FAIL"}
        @ts_err_pcode_msg            = "手机验证码发送失败"
        @ts_err_pcode_code           = "9002"
        @ts_err_pcode_desc           = "E_MOBILE_CODE_SEND_FAIL"
        # {"err_code"=>"9001", "err_msg"=>"\u624B\u673A\u53F7\u7801\u4E0D\u80FD\u4E3A\u7A7A", "err_desc"=>"E_MOBILE_IS_NULL"}
        @ts_err_phonull_msg          = "手机号码不能为空"
        @ts_err_phonull_errcode      = "9001"
        @ts_err_phonull_code_desc    = "E_MOBILE_IS_NULL"
        # {"err_code"=>"11003", "err_msg"=>"\u9A8C\u8BC1\u7801\u5931\u6548", "err_desc"=>"E_CODE_FAILURE"}
        @ts_err_pcoderr_msg          = "验证码失效"
        @ts_err_pcoderr_code         = "11003"
        @ts_err_pcoderr_desc         = "E_CODE_FAILURE"
        # {"err_code"=>"11002, "err_msg"=>"\u9a8c\u8bc1\u7801\u9519\u8bef\u6216\u5df2\u5931\u6548", "err_desc"=>"E_CODE_FAILURE"}
        @ts_err_pcodnul_msg          = "验证码错误或已失效"
        @ts_err_pcodnul_code         = "11002"
        @ts_err_pcodnul_desc         = "E_CODE_ERROR"
        #############################wuhongliang############################
        #############################liluping##############################################
        @ts_admin_usr                = "admin@zhilutec.com"
        @ts_app_redirect_uri         = "http://192.168.10.9"
        @ts_app_id_001               = "160727126008"
        @ts_app_name_001             = "IAMAPI_AutoTest_001"
        @ts_app_provider_001         = "IAMAPI_TEST自动化测试专用"
        @ts_app_comments_default_001 = "IAMAPI_TEST自动化测试专用"
    end

    #设置按xml顺序来执行
    #重新定义test_order
    def self.test_order_xml!
        class << self
            undef_method :test_order if method_defined? :test_order
            define_method :test_order do
                :xml
            end
        end
    end

    #设置按xml顺序来执行
    #当test_order为:xml时按xml文件顺序来执行
    def self.runnable_methods
        methods = methods_matching(/^test_/)
        if self.test_order == :xml
            methods
        else
            super
        end
    end

    def operate(str=" ")
        puts "[#{Time.new.strftime('%Y-%m-%d %H:%M:%S')}] "+str.to_gbk
        yield
    end

    test_order_xml! #xml，按xml顺序执行
    # i_suck_and_my_tests_are_order_dependent! #alpha，按alpha顺序执行
end