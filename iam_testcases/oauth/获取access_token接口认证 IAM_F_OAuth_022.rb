#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_OAuth_022", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_app_name1   = "黄瓜大良"
    @tc_app_prov1   = "湖南生化农场"
    @tc_app_comment = "湖南生化农场的花生"
    @tc_args1       = {name: @tc_app_name1, provider: @tc_app_prov1, redirect_uri: @ts_app_redirect_uri, comments: @tc_app_comment}
    @tc_app_status  = "1"
    @tc_phone       = "13100001111"
    @tc_pw          = "zhilutec123"
  end

  def process

    operate("1、ssh登录到IAM服务器；") {
    }

    operate("2、管理员创建应用") {
      tip = "管理员登录"
      puts "#{tip}".to_gbk
      rs_login = @iam_obj.manager_login
      assert_equal(@ts_admin_log_rs, rs_login["result"], "#{tip}失败!")

      @mana_uid   = rs_login["uid"]
      @mana_token = rs_login["token"]

      step = "管理员创建并激活应用"
      puts "#{step}".to_gbk
      rs =@iam_obj.qc_app(@tc_app_name1, @mana_token, @mana_uid, @tc_args1, @tc_app_status)
      assert_equal(@ts_admin_log_rs, rs["result"], "#{step}失败!")
      assert_equal(@ts_modify_msg, rs["msg"], "#{step}失败!")

      step1 = "管理员查询应用'#{@tc_app_name1}'信息"
      puts "#{step1}".to_gbk
      rs_app = @iam_obj.get_spec_app_info(@mana_token, @tc_app_name1, @mana_uid)
      assert_equal(@tc_app_name1, rs_app["name"], "#{step1}失败!")
      @app_id    = rs_app["client_id"]
      @app_secret= rs_app["client_secret"]
    }

    operate("3、用户注册") {
      args     = {"type" => "account", "cond" => @tc_phone}
      rs_users = @iam_obj.get_user_list(@mana_uid, @mana_token, args)
      if rs_users["users"].empty?||rs_users["users"][0]["account"]==@tc_phone
        @iam_obj.register_phoneusr(@tc_phone, @tc_pw)
      end
    }

    operate("4、用户登录并绑定应用") {
      step1 = "用户'#{@tc_phone}'登录"
      puts "#{step1}".to_gbk
      rs_usr =@iam_obj.user_login(@tc_phone, @tc_pw)
      assert_equal(@ts_admin_log_rs, rs_usr["result"], "#{step1}失败!")
      assert_equal(@tc_phone, rs_usr["account"], "#{step1}失败!")

      @usr_login_id =rs_usr["uid"]
      token         =rs_usr["access_token"]

      step2 = "用户'#{@tc_phone}'登录后查询应用"
      puts "#{step2}".to_gbk
      rs      = @iam_obj.user_app_list_bytype(@tc_app_name1, @usr_login_id, token, true)
      appname = rs["apps"][0]["name"]
      assert_equal(@tc_app_name1, appname, "#{step2}失败!")

      data  ={"client_id" => rs["apps"][0]["client_id"]}
      step3 = "用户'#{@tc_phone}'登录后绑定应用"
      puts "#{step3}".to_gbk
      rs_bind = @iam_obj.usr_binding_app(token, @usr_login_id, data)
      assert_equal(@ts_admin_log_rs, rs_bind["result"], "#{step3}失败!")
      assert_equal(@ts_msg_ok, rs_bind["msg"], "#{step3}失败!")
    }

    operate("5、用户oauth登录,获取用户userid；") {
      tip           = "用户'#{@tc_phone}'oauth登录"
      @oauth_userid = @iam_obj.usr_oauth_usrid(@tc_phone, @tc_pw, @app_secret, @app_id)
      usr_id        = @iam_obj.get_userid
      assert_equal(usr_id, @oauth_userid, "#{tip}失败!")
    }

    operate("6、获取接口认证code值；") {
      tip       = "用户'#{@tc_phone}'oauth登录获取接口认证code"
      @usr_code = @iam_obj.usr_oauth_code(@oauth_userid, @app_id, @app_secret)
      code      = @iam_obj.get_code
      assert_equal(code, @usr_code, "#{tip}失败!")
    }

    operate("7、code有效期内获取认证access_token值；") {
      rs      = @iam_obj.usr_oauth_token(@usr_code, @app_id, @app_secret)
      token   = rs["access_token"].to_s
      user_id = rs["user_id"]
      assert_equal(@usr_login_id, user_id, "code有效期内获取认证access_token值失败!")
      refute_empty(token, "code有效期内获取认证access_token值失败!")
    }

  end

  def clearup
    operate("1.用户解除绑定") {
      @iam_obj.usr_qub_app(@tc_phone, @tc_pw, @tc_app_name1, true)
    }

    operate("2.删除应用") {
      @iam_obj.mana_del_app(@tc_app_name1)
    }
  end

}
