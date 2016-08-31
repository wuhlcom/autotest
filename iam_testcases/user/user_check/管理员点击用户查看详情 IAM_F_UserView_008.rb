#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_UserView_008", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_phone_usr   = "13701424444"
    @tc_usr_pw      = "123456"
    @tc_usr_regargs = {type: "account", cond: @tc_phone_usr}
  end

  def process

    operate("1、ssh登录IAM服务器；") {
      rs= @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
      assert_equal(@ts_add_rs, rs["result"], "用户#{@tc_phone_usr}注册失败")

      @res         = @iam_obj.manager_login #管理员登录->得到uid和token
      @admin_id    = @res["uid"]
      @admin_token = @res["token"]
    }

    operate("2、获取知路管理员token值；") {

    }

    operate("3、获取用户id；") {
      rs = @iam_obj.user_login(@tc_phone_usr, @tc_usr_pw)
      @usr_id = rs["uid"]
    }

    operate("4、查询某个用户详情") {
      p rs = @iam_obj.get_user_details(@admin_id, @admin_token, @usr_id)
      assert_equal(@tc_phone_usr, rs["account"], "查询用户详细信息中账户信息失败")
      assert_equal(@usr_id, rs["id"], "查询用户详细信息用户id失败")
      assert_nil(rs["name"], "查询用户详细信息用户name失败")
      assert_nil(rs["sex"], "查询用户详细信息用户sex失败")
      assert_nil(rs["qq"], "查询用户详细信息用户qq失败")
      assert_nil(rs["mobile"], "查询用户详细信息用户mobile失败")
      assert_nil(rs["email"], "查询用户详细信息用户mobile失败")
      assert_empty(rs["apps"], "查询用户详细信息用户mobile失败")
    }
  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
    }
  end

}
