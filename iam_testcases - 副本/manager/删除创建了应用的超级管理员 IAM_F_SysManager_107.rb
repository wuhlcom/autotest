#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_107", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_account1 = "klwn101@163.com"
    @tc_passwd   = "123456"
    @tc_nickname = "hualaxiang"
    @tc_commnets = "sub manager"
    @tc_app_name = "SubAPPCome"
    @tc_args     ={"name"         => @tc_app_name,
                   "provider"     => "autotest",
                   "redirect_uri" => @ts_app_redirect_uri,
                   "comments"     => "autotest"}
  end

  def process

    operate("1、ssh登录IAM服务器；") {
    }

    operate("2、获取知路管理员token值；") {
    }

    operate("3、知路管理员下新增超级管理员；") {
      #首先在确保将要创建管理员下没有应用
      rs = @iam_obj.get_mlist_byname(@tc_account1)
      if !rs["res"].empty?&&@tc_account1==rs["res"][0]["name"]
        puts "如果超级管理员#{@tc_account1}已经存在，删除其应用".to_gbk
        @iam_obj.mana_del_app(@tc_app_name, nil, @tc_account1, @tc_passwd)
      else
        puts "知路管理员创建超级管理员#{@tc_account1}".to_gbk
        rs_login = @iam_obj.manager_del_add(@tc_account1, @tc_passwd, @tc_nickname)
        assert_equal(@ts_admin_log_rs, rs_login["result"], "创建账户#{@tc_account1}失败!")
      end
    }

    operate("4、登录超级管理员获取id和token值") {
    }

    operate("5、超级管理员下新增一个应用：") {
      rs_app = @iam_obj.mana_create_app(@tc_args, @tc_account1, @tc_passwd)
      assert_equal(@ts_admin_log_rs, rs_app["result"], "新增一个应用失败!")
      assert_equal(@ts_msg_ok, rs_app["msg"], "新增一个应用失败!")
    }

    operate("6、知路管理员下删除已创建的超级管理员：其中uid为登录管理员ID，userid为待删除管理员ID，token值为登录管理员token值；") {
      rs = @iam_obj.del_manager(@tc_account1)
      puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
      assert_equal(@ts_err_manappex_code, rs["err_code"], "存在应用的管理删除时返回code错误!")
      assert_equal(@ts_err_manappex_msg, rs["err_msg"], "存在应用的管理删除时返回msg错误!")
      assert_equal(@ts_err_manappex_desc, rs["err_desc"], "存在应用的管理删除时返回desc错误!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      rs = @iam_obj.get_mlist_byname(@tc_account1)
      if @tc_account1==rs["res"][0]["name"]
        @iam_obj.mana_del_app(@tc_app_name, nil, @tc_account1, @tc_passwd)
        @iam_obj.del_manager(@tc_account1)
      else
        @iam_obj.del_manager(@tc_account1)
      end
    }
  end

}
