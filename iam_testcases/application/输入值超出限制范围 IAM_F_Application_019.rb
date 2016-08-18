#
# description:
# 无错误码，需要修改IAM接口
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_019", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_app_name1   = "海鲜一号"
    @tc_app_prov1   = "生鲜馆"
    @tc_app_comment = "包子馒头年糕蛋ABC"*25+"螃蟹龙虾鱿鱼"
    @tc_args1       ={"name"         => @tc_app_name1,
                      "provider"     => @tc_app_prov1,
                      "redirect_uri" => @ts_app_redirect_uri,
                      "comments"     => @tc_app_comment}
  end

  def process

    operate("1、ssh登录IAM服务器；") {
    }

    operate("2、获取知路管理员token值；") {
    }

    operate("3、创建应用，comments输入为空；") {
      tip = "创建的应用名'#{@tc_app_name1}'，应用简介内容大小为#{@tc_app_comment.size}"
      puts "#{tip}".to_gbk
      p rs_app = @iam_obj.mana_create_app(@tc_args1)
      puts "RESULT err_msg:'#{rs_app['err_msg']}'".encode("GBK")
      puts "RESULT err_code:'#{rs_app['err_code']}'".encode("GBK")
      puts "RESULT err_desc:'#{rs_app['err_desc']}'".encode("GBK")
      assert_equal(@ts_err_appexists_msg, rs_app["err_msg"], "#{tip}返回错误消息不正确!")
      assert_equal(@ts_err_appexists_code, rs_app["err_code"], "#{tip}返回错误code不正确!")
      assert_equal(@ts_err_appexists_desc, rs_app["err_desc"], "#{tip}返回错误desc不正确!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {

    }
  end

}
