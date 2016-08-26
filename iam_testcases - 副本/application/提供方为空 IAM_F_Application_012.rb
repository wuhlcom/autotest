#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_012", "level" => "P4", "auto" => "n"}

  def prepare
    @tc_app_name = "APP_PRO_NUL"
    @tc_app_pro  = ""
    @tc_args     ={"name"         => @tc_app_name,
                   "provider"     => @tc_app_pro,
                   "redirect_uri" => @ts_app_redirect_uri,
                   "comments"     => "autotest"}
  end

  def process

    operate("1��ssh��¼IAM��������") {
    }

    operate("2����ȡ֪·����Աtokenֵ��") {
    }

    operate("3������Ӧ�ã�provider����Ϊ�գ�") {
      tip = "������Ӧ��ʱ�ṩ������Ϊ��"
      puts "#{tip}".to_gbk
     p rs_app = @iam_obj.mana_create_app(@tc_args)
      puts "RESULT err_msg:'#{rs_app['err_msg']}'".encode("GBK")
      puts "RESULT err_code:'#{rs_app['err_code']}'".encode("GBK")
      puts "RESULT err_desc:'#{rs_app['err_desc']}'".encode("GBK")
      assert_equal(@ts_err_appnulpro_msg, rs_app["err_msg"], "#{tip}���ش�����Ϣ����ȷ!")
      assert_equal(@ts_err_appnulpro_code, rs_app["err_code"], "#{tip}���ش���code����ȷ!")
      assert_equal(@ts_err_appnulpro_desc, rs_app["err_desc"], "#{tip}���ش���desc����ȷ!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {

    }
  end

}
