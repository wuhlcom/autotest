#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_132", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_man_name  = "jianbang@zhilutec.com"
    @tc_nickname  = "肩膀上的生活"
    @tc_passwd    = "zhilutec"
    @tc_comments  = "扛起来"
    @tc_comments1 = ("白日依山尽，黄河入海流，欲穷千里目，更上一层楼，行到水穷处，坐看云起时，数风流人物，"*6+"还看今朝")
    @tc_args1     = {"nickname" => @tc_nickname, "comments" => @tc_comments1}
  end

  def process

    operate("1、ssh登录IAM服务器；") {
    }

    operate("2、获取系统管理员uid和token值；") {
      #如果管理员已经存在则先删除
      @iam_obj.del_manager(@tc_man_name)
      puts "新增管理员:‘#{@tc_man_name}’".encode("GBK")
      rs = @iam_obj.manager_add(@tc_man_name, @tc_nickname, @tc_passwd, "2", @tc_comments)
      puts "RESULT MSG:#{rs['msg']}".encode("GBK")
      assert_equal(@ts_add_rs, rs["result"], "添加系统管理员失败!")
      assert_equal(@ts_add_msg, rs["msg"], "添加系统管理员失败!")
    }

    operate("3、修改comments信息长度为#{@tc_args1["comments"].size}；") {
      puts "修改comments长度为#{@tc_args1["comments"].size}".to_gbk
      rs = @iam_obj.edit_mana_info(@tc_args1, @tc_man_name, @tc_passwd)
      assert_equal(@ts_add_rs, rs["result"], "系统管理员备注长度为#{@tc_args1["comments"].size}失败!")

      rs_query = @iam_obj.get_mlist_byname(@tc_man_name)
      assert_equal(@tc_comments1.chop!, rs_query["comments"], "系统管理员备注截断后内容不正确定!")
    }
  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.del_manager(@tc_man_name)
    }
  end

}
