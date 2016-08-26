#
# description:
# �޴����룬��Ҫ�޸�IAM�ӿ�
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_019", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_app_name1   = "����һ��"
    @tc_app_prov1   = "���ʹ�"
    @tc_app_comment = "������ͷ��⵰ABC"*25+"�з��Ϻ����"
    @tc_args1       ={"name"         => @tc_app_name1,
                      "provider"     => @tc_app_prov1,
                      "redirect_uri" => @ts_app_redirect_uri,
                      "comments"     => @tc_app_comment}
  end

  def process

    operate("1��ssh��¼IAM��������") {
    }

    operate("2����ȡ֪·����Աtokenֵ��") {
    }

    operate("3������Ӧ�ã�comments����Ϊ�գ�") {
      tip = "������Ӧ����'#{@tc_app_name1}'��Ӧ�ü�����ݴ�СΪ#{@tc_app_comment.size}"
      puts "#{tip}".to_gbk
      p rs_app = @iam_obj.mana_create_app(@tc_args1)
      puts "RESULT err_msg:'#{rs_app['err_msg']}'".encode("GBK")
      puts "RESULT err_code:'#{rs_app['err_code']}'".encode("GBK")
      puts "RESULT err_desc:'#{rs_app['err_desc']}'".encode("GBK")
      assert_equal(@ts_err_appexists_msg, rs_app["err_msg"], "#{tip}���ش�����Ϣ����ȷ!")
      assert_equal(@ts_err_appexists_code, rs_app["err_code"], "#{tip}���ش���code����ȷ!")
      assert_equal(@ts_err_appexists_desc, rs_app["err_desc"], "#{tip}���ش���desc����ȷ!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {

    }
  end

}
