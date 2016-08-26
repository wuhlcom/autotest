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
    @iam_obj               =IAMAPI::IAM.new
    #http get
    #get userid
    @ts_url_userid         = "http://192.168.10.9:8082/userid.txt"
    #get code
    @ts_url_usercode       = "http://192.168.10.9:8082/code.txt"
    @ts_admin_usr          = "admin2@zhilutec.com"
    @ts_admin_pw           = "123123"
    @ts_admin_code         = "1234"
    @ts_admin_login        = "http://192.168.10.9:8080/index.php/Login/index.html"
    @file_path             = File.expand_path("../process_files", __FILE__)
    @ts_ko1                = "autotest_01.ko"
    @ts_so1                = "autotest_01.so"
    @ts_bin1               = "autotest_01.bin"
    @ts_file_ko1           = "#{@file_path}/#{@ts_ko1}"
    @ts_file_so1           = "#{@file_path}/#{@ts_so1}"
    @ts_file_bin1          = "#{@file_path}/#{@ts_bin1}"

    # {"result":1,"name":"admin@zhilutec.com","nickname":"\u77e5\u8def\u7ba1\u7406\u5458","uid":"1","role_code":"1","token":"e4f0326fa441186b18dcd66dc4509466"}
    @ts_login_url          = "http://192.168.10.9:8082/admins/dologin"
    @ts_admin_log_rs       = 1
    @ts_admin_log_name     = "admin2@zhilutec.com"
    @ts_admin_log_pw       = "123123"
    @ts_admin_log_nickname = "知路管理员"
    @ts_admin_log_uid      = "1"
    @ts_admin_rcode        = "1"

    @ts_err_accformat         = "帐号格式错误"
    @ts_err_accformat_code    = "5003"
    @ts_err_accformat_desc    = "E_ACCOUNT_FORMAT_ERROR"

    #manager add
    @ts_add_rs                = 1
    @ts_msg_ok                = "OK"
    @ts_add_msg               = "添加成功"
    @ts_modify_msg            = "修改成功"
    @ts_delete_msg            = "删除成功"

    # {"err_code" => "5006", "err_msg" => "\u5E10\u53F7\u5DF2\u5B58\u5728", "err_desc" => "E_ACCOUNT_EXISTS_ERROR"}
    @ts_err_acc_exists        = "帐号已存在"
    @ts_err_acc_exists_code   = "5006"
    @ts_err_acc_exists_desc   = "E_ACCOUNT_EXISTS_ERROR"
    # {"err_code"=>"5004", "err_msg"=>"\u6635\u79F0\u683C\u5F0F\u9519\u8BEF", "err_desc"=>"E_NICKNAME_FORMAT_ERROR"}
    @ts_err_nickformat        = "昵称格式错误"
    @ts_err_nickformat_code   = "5004"
    @ts_err_nickformat_desc   = "E_NICKNAME_FORMAT_ERROR"

    # {"err_code"=>"21006", "err_msg"=>"\u89D2\u8272id\u9519\u8BEF", "err_desc"=>"E_ROLE_ERROR"}
    @ts_err_roleid            = "角色id错误"
    @ts_err_roleid_code       = "21006"
    @ts_err_roleid_desc       = "E_ROLE_ERROR"
    # {"err_code" => "5005", "err_msg" => "\u5BC6\u7801\u683C\u5F0F\u9519\u8BEF", "err_desc" => "E_PASSWD_FORMAT_ERROR"}
    @ts_err_pwformat          = "密码格式错误"
    @ts_err_pwformat_code     = "5005"
    @ts_err_pwformat_desc     = "E_PASSWD_FORMAT_ERROR"

    # {"err_code"=>"10001", "err_msg"=>"\u5E10\u53F7\u6216\u5BC6\u7801\u9519\u8BEF", "err_desc"=>"E_USER_PWD_ERROR"}
    @ts_err_login             = "帐号或密码错误"
    @ts_err_login_code        = "10001"
    @ts_err_login_desc        = "E_USER_PWD_ERROR"
    # {"err_code"=>"9002", "err_msg"=>"\u624B\u673A\u9A8C\u8BC1\u7801\u53D1\u9001\u5931\u8D25", "err_desc"=>"E_MOBILE_CODE_SEND_FAIL"}
    @ts_err_pcode_msg         = "手机验证码发送失败"
    @ts_err_pcode_code        = "9002"
    @ts_err_pcode_desc        = "E_MOBILE_CODE_SEND_FAIL"
    # {"err_code"=>"9001", "err_msg"=>"\u624B\u673A\u53F7\u7801\u4E0D\u80FD\u4E3A\u7A7A", "err_desc"=>"E_MOBILE_IS_NULL"}
    @ts_err_phonull_msg       = "手机号码不能为空"
    @ts_err_phonull_errcode   = "9001"
    @ts_err_phonull_code_desc = "E_MOBILE_IS_NULL"
    # {"err_code"=>"11003", "err_msg"=>"\u9A8C\u8BC1\u7801\u5931\u6548", "err_desc"=>"E_CODE_FAILURE"}
    @ts_err_pcoderr_msg       = "验证码失效"
    @ts_err_pcoderr_code      = "11003"
    @ts_err_pcoderr_desc      = "E_CODE_FAILURE"
    # {"err_code"=>"11002, "err_msg"=>"\u9a8c\u8bc1\u7801\u9519\u8bef\u6216\u5df2\u5931\u6548", "err_desc"=>"E_CODE_FAILURE"}
    @ts_err_pcodnul_msg       = "验证码错误或已失效"
    @ts_err_pcodnul_code      = "11002"
    @ts_err_pcodnul_desc      = "E_CODE_ERROR"

    @ts_err_pwerr_msg      = "密码格式错误"
    @ts_err_pwerr_code     = "5005"
    @ts_err_pwerr_desc     = "E_PASSWD_FORMAT_ERROR"
    # {"err_code"=>"10001", "err_msg"=>"\u5E10\u53F7\u6216\u5BC6\u7801\u9519\u8BEF", "err_desc"=>"E_USER_PWD_ERROR"}
    @ts_err_acc_msg        = "帐号或密码错误"
    @ts_err_acc_code       = "10001"
    @ts_err_acc_desc       = "E_USER_PWD_ERROR"
    # {"err_code"=>"5001", "err_msg"=>"\u90AE\u7BB1\u683C\u5F0F\u9519\u8BEF", "err_desc"=>"E_EMAIL_FORMAT_ERROR"}
    @ts_err_email_msg      = "邮箱格式错误"
    @ts_err_email_code     = "5001"
    @ts_err_email_desc     = "E_EMAIL_FORMAT_ERROR"
    # {"err_code"=>"11004", "err_msg"=>"\u90AE\u7BB1\u4E0D\u5B58\u5728", "err_desc"=>"E_EMAIL_NOTFOUND"}
    @ts_err_noemail_msg    = "邮箱不存在"
    @ts_err_noemail_code   = "11004"
    @ts_err_noemail_desc   = "E_EMAIL_NOTFOUND"
    # {"err_code"=>"21005", "err_msg"=>"\u5E10\u53F7\u4E0B\u5B58\u5728\u5E94\u7528\u4E0D\u80FD\u5220\u9664", "err_desc"=>"E_USER_APP_ERROR"}
    @ts_err_manappex_msg   = "帐号下存在应用不能删除"
    @ts_err_manappex_code  = "21005"
    @ts_err_manappex_desc  = "E_USER_APP_ERROR"
    # {"err_code"=>"21003", "err_msg"=>"\u5B58\u5728\u4E0B\u7EA7\u5E10\u53F7\u4E0D\u80FD\u5220\u9664", "err_desc"=>"E_DEL_USER_ERROR"}
    @ts_err_manadel_msg    = "存在下级帐号不能删除"
    @ts_err_manadel_code   = "21003"
    @ts_err_manadel_desc   = "E_DEL_USER_ERROR"
    # {"err_code"=>"60003", "err_msg"=>"AccessToken\u4E3A\u7A7A", "err_desc"=>"E_ACCESS_TOKEN_NULL"}
    @ts_err_manaquery_msg  = "AccessToken为空"
    @ts_err_manaquery_code = "60003"
    @ts_err_manaquery_desc = "E_ACCESS_TOKEN_NULL"
    # {"err_code"=>"22006", "err_msg"=>"\u5E94\u7528\u540D\u79F0\u683C\u5F0F\u9519\u8BEF", "err_desc"=>"E_APP_NAME_FORMAT_ERROR"}
    @ts_err_appformat_msg  = "应用名称格式错误"
    @ts_err_appformat_code = "22006"
    @ts_err_appformat_desc = "E_APP_NAME_FORMAT_ERROR"
    # {"err_code"=>"22005", "err_msg"=>"\u5E94\u7528\u540D\u79F0\u4E3A\u7A7A", "err_desc"=>"E_APP_NAME_NULL"}
    @ts_err_appnul_msg     = "应用名称为空"
    @ts_err_appnul_code    = "22005"
    @ts_err_appnul_desc    = "E_APP_NAME_NULL"
    # {"err_code"=>"22007", "err_msg"=>"\u5E94\u7528\u540D\u79F0\u5DF2\u5B58\u5728", "err_desc"=>"E_APP_NAME_EXIST"}
    @ts_err_appexists_msg  = "应用名称已存在"
    @ts_err_appexists_code = "22007"
    @ts_err_appexists_desc = "E_APP_NAME_EXIST"

    @ts_err_apppro_msg           = "应用提供方格式错误"
    @ts_err_apppro_code          = "22009"
    @ts_err_apppro_desc          = "E_APP_PROVIDER_FORMAT_ERROR"
    # {"err_code"=>"22008", "err_msg"=>"\u5E94\u7528\u63D0\u4F9B\u65B9\u4E3A\u7A7A", "err_desc"=>"E_APP_PROVIDER_NULL"}
    @ts_err_appnulpro_msg        = "应用提供方为空"
    @ts_err_appnulpro_code       = "22008"
    @ts_err_appnulpro_desc       = "E_APP_PROVIDER_NULL"
    # {"err_code"=>"22011", "err_msg"=>"\u5E94\u7528\u56DE\u8C03\u5730\u5740\u683C\u5F0F\u9519\u8BEF", "err_desc"=>"E_REDIRECT_URI_FORMAT_ERROR"}
    @ts_err_appurl_msg           = "应用回调地址格式错误"
    @ts_err_appurl_code          = "22011"
    @ts_err_appurl_desc          = "E_REDIRECT_URI_FORMAT_ERROR"
    # {"err_code"=>"22010", "err_msg"=>"\u5E94\u7528\u63D0\u4F9B\u65B9\u4E3A\u7A7A", "err_desc"=>"E_APP_REDIRECT_URI_NULL"}
    @ts_err_appnulurl_msg        = "应用提供方为空"
    @ts_err_appnulurl_code       = "22010"
    @ts_err_appnulurl_desc       = "E_APP_REDIRECT_URI_NULL"
    # {"error"=>"expired_code", "error_code"=>50000}
    @ts_err_oauth_code           = 50000
    @ts_err_oauth_msg            = "expired_code"
    # {"err_code"=>"60004", "err_msg"=>"AccessToken\u9519\u8BEF", "err_desc"=>"E_ACCESS_TOKEN_ERROR"}
    @ts_err_oauthtoken_msg       = "AccessToken错误"
    @ts_err_oauthtoken_code      = "60004"
    @ts_err_oauthtoken_desc      = "E_ACCESS_TOKEN_ERROR"
    # {"err_code"=>"60003", "err_msg"=>"AccessToken\u4E3A\u7A7A", "err_desc"=>"E_ACCESS_TOKEN_NULL"}
    @ts_err_oauthtokennul_msg    = "AccessToken为空"
    @ts_err_oauthtokennul_code   = "60003"
    @ts_err_oauthtokennul_desc   = "E_ACCESS_TOKEN_NULL"
    # E_CLIENT_ID_ERROR	60002	应用ID错误
    @ts_err_oauthappid_msg       = "应用ID错误"
    @ts_err_oauthappid_code      = "60002"
    @ts_err_oauthappid_desc      = "E_CLIENT_ID_ERROR"
    # {"err_code":"60005","err_msg":"AccessToken\u8fc7\u671f","err_desc":"E_ACCESS_TOKEN_EXPIRE"}
    @ts_err_oautokenex_msg       = "AccessToken过期"
    @ts_err_oautokenex_code      = "60005"
    @ts_err_oautokenex_desc      = "E_ACCESS_TOKEN_EXPIRE"
    # {"err_code"=>"40007", "err_msg"=>"\u8BE5\u8BBE\u5907\u4E3A\u65E0\u6548\u8BBE\u5907", "err_desc"=>"E_QUERY_DEVICE_ID_FAIL"}
    @ts_err_devauth_msg          = "该设备为无效设备"
    @ts_err_devauth_code         = "40007"
    @ts_err_devauth_desc         = "E_QUERY_DEVICE_ID_FAIL"
    @ts_err_devmac_msg           = "设备MAC已存在"
    @ts_err_devmac_code          = "40004"
    @ts_err_devmac_desc          = "E_DEV_MAC_EXISTS"
    # RESULT err_msg:'设备名称为空'
    @ts_err_devnul_msg           = "设备名称为空"
    @ts_err_devnul_code          = "40006"
    @ts_err_devnul_desc          = "E_DEV_NAME_NULL"
    # E_DEVICE_NAME_EXISTS	40009	设备名称已存在
    @ts_err_devexists_msg        = "设备名称已存在"
    @ts_err_devexists_code       = "40009"
    @ts_err_devexists_desc       = "E_DEVICE_NAME_EXISTS"
    # {"err_code"=>"11005", "err_msg"=>"\u65E7\u5BC6\u7801\u9519\u8BEF", "err_desc"=>"E_OLDPWD_ERROR"}
    @ts_err_oldpw_msg            = "旧密码错误"
    @ts_err_oldpw_code           = "11005"
    @ts_err_oldpw_desc           = "E_OLDPWD_ERROR"
    #
    @ts_err_pwsame_msg           = "新密码和旧密码相同"
    @ts_err_pwsame_code          = "11006"
    @ts_err_pwsame_desc          = "E_NEWPWD_EQUAL_OLDPWD"
    #############################wuhongliang############################
    #############################liluping##############################################
    @ts_admin_usr                = "admin@zhilutec.com"
    @ts_app_redirect_uri         = "http://192.168.10.9"
    @ts_app_id_001               = "160727126008"
    @ts_app_name_001             = "IAMAPI_AutoTest_001"
    @ts_app_provider_001         = "IAMAPI_TEST自动化测试专用"
    @ts_app_comments_default_001 = "IAMAPI_TEST自动化测试专用"
    @ts_app_system_manage        = "system@zhilutec.com" # 系统管理员
    @ts_usr_name                 = "15814037400"
    @ts_usr_pwd                  = "123123"
    @ts_usr_name_config          = "config@zhilutec.com"
    @ts_usr_pwd_config           = "123456"
    @ts_usr_name_monitor         = "monitor@zhilutec.com"
    @ts_usr_pwd_monitor          = "123456"

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
