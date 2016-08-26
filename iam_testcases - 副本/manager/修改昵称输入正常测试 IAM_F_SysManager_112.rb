#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_112", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_man_name = "xinjiang@zhilutec.com"
    @tc_nickname = "新疆红枣"
    @tc_passwd   = "zhilutec"
    @tc_args1    = {"nickname" => "1", "comments" => "新疆哈密瓜"}
    @tc_args2    = {"nickname" => "235"*10+"gu", "comments" => "新疆沙漠"}
    @tc_args3    = {"nickname" => "woshi新疆西瓜", "comments" => "新疆哈密瓜"}
    @tc_args     = [@tc_args1, @tc_args2, @tc_args3]
  end

  def process

    operate("1、ssh登录IAM服务器；") {
    }

    operate("2、获取系统管理员uid和token值；") {
      #如果管理员已经存在则先删除
      @iam_obj.del_manager(@tc_man_name)
      puts "新增管理员:‘#{@tc_man_name}’".encode("GBK")
      rs = @iam_obj.manager_add(@tc_man_name, @tc_nickname, @tc_passwd)
      puts "RESULT MSG:#{rs['msg']}".encode("GBK")
      assert_equal(@ts_add_rs, rs["result"], "添加系统管理员失败!")
      assert_equal(@ts_add_msg, rs["msg"], "添加系统管理员失败!")
    }

    operate("3、修改nickname信息；") {
      @tc_args.each do |args|
        puts "昵称#{args["nickname"]}的长度为#{args["nickname"].size}".to_gbk
        rs = @iam_obj.edit_mana_info(args, @tc_man_name, @tc_passwd)
        assert_equal(@ts_add_rs, rs["result"], "系统管理员昵称为#{args["nicname"]}失败!")
      end
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.del_manager(@tc_man_name)
    }
  end

}
