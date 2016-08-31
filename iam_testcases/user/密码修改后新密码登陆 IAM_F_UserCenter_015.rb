#
# description:
# author:liiluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_UserCenter_015", "level" => "P2", "auto" => "n"}

  def prepare
    @tc_phone_usr   = "13700008889"
    @tc_usr_pw      = "123456"
    @tc_usr_regargs = {type: "account", cond: @tc_phone_usr}
    @tc_new_pwd     = "zhilutec"
  end

  def process

    operate("1、ssh登录IAM服务器；") {
      rs= @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
      assert_equal(@ts_add_rs, rs["result"], "用户#{@tc_phone_usr}注册失败")
    }

    operate("2、登录用户获取access_token值和uid号；") {
      rs     = @iam_obj.user_login(@tc_phone_usr, @tc_usr_pw)
      @uid   = rs["uid"]
      @token = rs["access_token"]
    }

    operate("3、修改密码；") {
      rs = @iam_obj.mofify_user_pwd(@tc_usr_pw, @tc_new_pwd, @uid, @token)
      assert_equal(1, rs["result"], "修改密码失败")
    }

    operate("4、使用新密码登录；") {
      rs = @iam_obj.user_login(@tc_phone_usr, @tc_new_pwd)
      assert_equal(1, rs["result"], "使用新密码登录失败")
      @new_uid   = rs["uid"]
      @new_token = rs["access_token"]
    }

  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
      @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_new_pwd)
    }
  end

}
