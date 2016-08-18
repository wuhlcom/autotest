#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_117", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_man_name1 = "jiandan@zhilutec.com"
    @tc_man_name2 = "shuizhu@zhilutec.com"
    @tc_nickname1 = "煎蛋妹"
    @tc_nickname2 = "煎蛋哥"
    @tc_passwd    = "zhilutec"
    @tc_args1     = {"nickname" => @tc_nickname2, "comments" => "jiandan"}

  end

  def process

    operate("1、ssh登录IAM服务器；") {
    }

    operate("2、获取系统管理员id号和token值；") {
      #如果管理员已经存在则先删除
      @iam_obj.del_manager(@tc_man_name1)
      puts "新增管理员:‘#{@tc_man_name1}’".encode("GBK")
      rs = @iam_obj.manager_add(@tc_man_name1, @tc_nickname1, @tc_passwd)
      puts "RESULT MSG:#{rs['msg']}".encode("GBK")
      assert_equal(@ts_add_rs, rs["result"], "添加系统管理员#{@tc_man_name1}失败!")
      assert_equal(@ts_add_msg, rs["msg"], "添加系统管理员#{@tc_man_name1}失败!")

      @iam_obj.del_manager(@tc_man_name2)
      puts "新增管理员:‘#{@tc_man_name2}’".encode("GBK")
      rs = @iam_obj.manager_add(@tc_man_name2, @tc_nickname2, @tc_passwd)
      puts "RESULT MSG:#{rs['msg']}".encode("GBK")
      assert_equal(@ts_add_rs, rs["result"], "添加系统管理员#{@tc_man_name2}失败!")
      assert_equal(@ts_add_msg, rs["msg"], "添加系统管理员#{@tc_man_name2}失败!")
    }

    operate("3、修改nickname信息为已存在的昵称；") {
      puts "修改管理员#{@tc_man_name2}昵称为'#{@tc_nickname1}'与管理员#{@tc_man_name1}的昵称一致".to_gbk
      rs = @iam_obj.edit_mana_info(@tc_args1, @tc_man_name2, @tc_passwd)
      assert_equal(@ts_add_rs, rs["result"], "修改昵称为'#{@tc_args1["nickname"]}失败!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.del_manager(@tc_man_name1)
      @iam_obj.del_manager(@tc_man_name2)
    }
  end

}
