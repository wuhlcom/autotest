#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
  attr = {"id" => "ZLBF_21.1.49", "level" => "P1", "auto" => "n"}

  def prepare
  end

  def process
    operate("1 Ĭ���������") {
      rs_login = login_recover(@browser, @ts_powerip, @ts_default_ip)
      assert(rs_login, "ʹ��Ĭ�������¼·����ʧ�ܣ�")
    }
  end

  def clearup

  end

}
