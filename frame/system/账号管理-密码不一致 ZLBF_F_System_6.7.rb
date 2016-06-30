#
# description:
#  C013��Ʒ�����⣬�������������Ҳ�����룬�Ҵ�����ʾ��Ϣ��ʾ�Ŀ�����λ����һ��
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
  attr = {"id" => "ZLBF_F_System_6.7", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_pw_error= "�������벻һ��"
    @tc_new_pw1 = "admin1"
    @tc_new_pw2 = "admin2"
  end

  def process

    operate("1����¼DUT����ҳ�棬���˻�����ҳ�棻") {
      rs_login = login_recover(@browser, @ts_powerip, @ts_default_ip)
      assert(rs_login, "·������¼ʧ�ܣ�")

      @account_page = RouterPageObject::AccountPage.new(@browser)
      @account_page.open_account_page(@browser.url)
    }

    operate("2��ʹ��Ĭ���û��������������ȷ����������������벻ͬ������") {
      puts("�û���Ϊ��#{@ts_default_usr}".encode("GBK"))
      puts("�޸�����Ϊ:#{@tc_new_pw1}".encode("GBK"))
      puts("�޸�ȷ������Ϊ:#{@tc_new_pw2}".encode("GBK"))
      @account_page.input_usr(@ts_default_usr)
      @account_page.input_pw(@tc_new_pw1) # ��������
      @account_page.input_confirmpw(@tc_new_pw2) # ȷ������
    }

    operate("3������") {
      @account_page.save
      sleep 1
      error_msg = @account_page.error_msg
      puts("ERROR TIP:#{error_msg}".encode("GBK"))
      assert_equal(error_msg, @tc_pw_error, "���벻һ��Ҳ�ܱ���")
    }
  end

  def clearup

    operate("1 �ָ�Ĭ���˻�") {
      @account_page = RouterPageObject::AccountPage.new(@browser)
      rs            = @account_page.login_with_exists(@browser.url)
      if rs #�����ǰ�ǵ�¼���棬���ȵ�¼
        passwords =[@tc_new_pw1, @tc_new_pw2]
        flag      = false
        passwords.each do |pw|
          @account_page.login_with(@ts_default_usr, pw, @browser.url) #���ʻ���¼
          lan = @account_page.lan?
          if lan
            puts "�޸�ΪĬ���˻�!".to_gbk
            @account_page.modify_account(@browser.url, @ts_default_usr, @ts_default_pw) #���˻���¼�ɹ����޸��˻�ΪĬ��
            flag = true
            break
          end
        end

        unless flag
          @account_page.login_with(@ts_default_usr, @ts_default_pw, @browser.url) #���ʻ���¼ʧ�ܣ�����ʹ�þ��˻���¼
          lan = @account_page.lan?
          if lan
            puts "��ǰ�˻��Ѿ���Ĭ���˻�!".to_gbk
          else
            puts "�˻��쳣!".to_gbk
          end
        end
      else #�����ǰҳ�治�ǵ�¼ҳ�棬��˵�Ѿ���¼,��ֱ�ӻָ�ΪĬ���˻�
        puts "ֱ�ӻָ�ΪĬ���˻�!".to_gbk
        @account_page.modify_account(@browser.url, @ts_default_usr, @ts_default_pw)
      end
    }
  end

}
