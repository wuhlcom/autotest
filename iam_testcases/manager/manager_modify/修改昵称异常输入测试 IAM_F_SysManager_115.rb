#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_115", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_man_name = "aplle@zhilutec.com"
    @tc_nickname = "红苹果"
    @tc_passwd   = "zhilutec"
    @tc_args1    = {"nickname" => "5$@(!~x", "comments" => @tc_nickname}
    @tc_args2    = {"nickname" => "９５２７", "comments" => @tc_nickname}
  end

  def process

    operate("1、ssh登录IAM服务器；") {

    }

    operate("2、获取系统管理员id号和token值；") {
      #如果管理员已经存在则先删除
      @iam_obj.del_manager(@tc_man_name)
      puts "新增管理员:‘#{@tc_man_name}’".encode("GBK")
      rs = @iam_obj.manager_add(@tc_man_name, @tc_nickname, @tc_passwd)
      puts "RESULT MSG:#{rs['msg']}".encode("GBK")
      assert_equal(@ts_add_rs, rs["result"], "添加系统管理员失败!")
      assert_equal(@ts_add_msg, rs["msg"], "添加系统管理员失败!")
    }

    operate("3、修改nickname信息异常输入；") {
      puts "昵称为'#{@tc_args1["nickname"]}'".to_gbk
      rs = @iam_obj.edit_mana_info(@tc_args1, @tc_man_name, @tc_passwd)
      puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
      assert_equal(@ts_err_nickformat_code, rs["err_code"], "昵称为'#{@tc_args1["nickname"]}返回code错误!")
      assert_equal(@ts_err_nickformat, rs["err_msg"], "昵称为'#{@tc_args1["nickname"]}返回msg错误!")
      assert_equal(@ts_err_nickformat_desc, rs["err_desc"], "昵称为'#{@tc_args1["nickname"]}为空desc!")

      puts "昵称为'#{@tc_args2["nickname"]}'".to_gbk
      rs = @iam_obj.edit_mana_info(@tc_args2, @tc_man_name, @tc_passwd)
      puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
      assert_equal(@ts_err_nickformat_code, rs["err_code"], "昵称为'#{@tc_args2["nickname"]}返回code错误!")
      assert_equal(@ts_err_nickformat, rs["err_msg"], "昵称为'#{@tc_args2["nickname"]}返回msg错误!")
      assert_equal(@ts_err_nickformat_desc, rs["err_desc"], "昵称为'#{@tc_args2["nickname"]}返回desc错误!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.del_manager(@tc_man_name)
    }
  end

}
