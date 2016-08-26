#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_005", "level" => "P2", "auto" => "n"}

  def prepare
    @tc_app_name = "WWW1234567"*3+"888"
    @tc_args     ={"name"         => @tc_app_name,
                   "provider"     => "autotest",
                   "redirect_uri" => @ts_app_redirect_uri,
                   "comments"     => "autotest"}
  end

  def process

    operate("1��ssh��¼IAM��������") {
    }

    operate("2����ȡ֪·����Աtokenֵ��") {
    }

    operate("3������Ӧ�ã�������������33���ַ���") {
      tip = "������Ӧ��������Ϊ#{@tc_app_name.size}"
      puts "#{tip}".to_gbk
      rs_app = @iam_obj.mana_create_app(@tc_args)
      puts "RESULT err_msg:'#{rs_app['err_msg']}'".encode("GBK")
      puts "RESULT err_code:'#{rs_app['err_code']}'".encode("GBK")
      puts "RESULT err_desc:'#{rs_app['err_desc']}'".encode("GBK")
      assert_equal(@ts_err_appformat_msg, rs_app["err_msg"], "#{tip}���ش�����Ϣ����ȷ!")
      assert_equal(@ts_err_appformat_code, rs_app["err_code"], "#{tip}���ش���code����ȷ!")
      assert_equal(@ts_err_appformat_desc, rs_app["err_desc"], "#{tip}���ش���desc����ȷ!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.mana_del_app(@tc_app_name)
    }
  end

}
