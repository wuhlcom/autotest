#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_025", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_app_name1        = "ę́����"
    @tc_app_redirect_url = "http://www.ę́��.com/"
    @tc_args1            ={"name"         => @tc_app_name1,
                           "provider"     => "autotest",
                           "redirect_uri" => @tc_app_redirect_url,
                           "comments"     => "autotest"}
  end

  def process

    operate("1��ssh��¼IAM��������") {
    }

    operate("2����ȡ֪·����Աtokenֵ��") {
    }

    operate("3������Ӧ�ã�redirect_uri�������ģ�") {
      tip    = "����Ӧ����Ϊ'#{@tc_args1["name"]}"
      rs_app = @iam_obj.mana_create_app(@tc_args1)
      puts "RESULT err_msg:'#{rs_app['err_msg']}'".encode("GBK")
      puts "RESULT err_code:'#{rs_app['err_code']}'".encode("GBK")
      puts "RESULT err_desc:'#{rs_app['err_desc']}'".encode("GBK")
      assert_equal(@ts_err_appurl_msg, rs_app["err_msg"], "#{tip}���ش�����Ϣ����ȷ!")
      assert_equal(@ts_err_appurl_code, rs_app["err_code"], "#{tip}���ش���code����ȷ!")
      assert_equal(@ts_err_appurl_desc, rs_app["err_desc"], "#{tip}���ش���desc����ȷ!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {

    }
  end

}
