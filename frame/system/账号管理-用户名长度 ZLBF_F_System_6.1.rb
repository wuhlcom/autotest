#
# description:
# author:liluping
# date:2016-06-20
# modify:
#

testcase {
    attr = {"id" => "ZLBF_21.1.72", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_usr_new1 = "test"
        @tc_usr_new2 = "test_012345678901234567890123456"
        @tc_usr_new3 = "test_012345"
    end

    def process

        operate("1����¼DUT����ҳ�棬���˻�����ҳ�棻") {
            rs_login = login_recover(@browser, @ts_powerip, @ts_default_ip)
            assert(rs_login, "·������¼ʧ�ܣ�")

            @account_page = RouterPageObject::AccountPage.new(@browser)
            @account_page.open_account_page(@browser.url)
        }

        operate("2������4λ�û���,��test������ʹ��Ĭ�����룬���沢ʹ���޸ĺ���˻���¼·����") {
            puts("�޸��û���Ϊ#{@tc_usr_new1.size}�ַ�".encode("GBK"))
            puts("�޸��û���Ϊ��#{@tc_usr_new1}".encode("GBK"))
            puts("����Ϊ��#{@ts_default_pw}".encode("GBK"))
            @account_page.input_usr(@tc_usr_new1)
            @account_page.set_pw(@ts_default_pw) # ��������
            @account_page.save
            sleep 1
            rs = @account_page.login_with_exists(@browser.url)
            assert(rs, "�޸��˻�ʧ��")
            rs_login = login_no_default_ip(@browser, @tc_usr_new1, @ts_default_pw)
            assert(rs_login[:flag], "��¼ʧ�ܣ�")
        }

        operate("3������32λ�û���,��test_012345678901234567890123456������ʹ��Ĭ�����룬���沢ʹ���޸ĺ���˻���¼·����") {
            @account_page.open_account_page(@browser.url)
            puts("�޸��û���Ϊ#{@tc_usr_new2.size}�ַ�".encode("GBK"))
            puts("�޸��û���Ϊ��#{@tc_usr_new2}".encode("GBK"))
            puts("�޸�����Ϊ��#{@ts_default_pw}".encode("GBK"))
            @account_page.input_usr(@tc_usr_new2)
            @account_page.set_pw(@ts_default_pw) # ��������
            @account_page.save
            sleep 1
            rs = @account_page.login_with_exists(@browser.url)
            assert(rs, "�޸��˻�ʧ��")
            rs_login = login_no_default_ip(@browser, @tc_usr_new1, @ts_default_pw)
            assert(rs_login[:flag], "��¼ʧ�ܣ�")
        }

        operate("4������10λ�û���,��test_012345������ʹ��Ĭ�����룬���沢ʹ���޸ĺ���˻���¼·����") {
            @account_page.open_account_page(@browser.url)
            puts("�޸��û���Ϊ��#{@tc_usr_new3}".encode("GBK"))
            puts("�޸�����Ϊ��#{@tc_usr_new3}".encode("GBK"))
            @account_page.input_usr(@tc_usr_new3)
            @account_page.set_pw(@ts_default_pw) # ��������
            @account_page.save
            sleep 1
            rs = @account_page.login_with_exists(@browser.url)
            assert(rs, "�޸��˻�ʧ��")
            rs_login = login_no_default_ip(@browser, @tc_usr_new1, @ts_default_pw)
            assert(rs_login[:flag], "��¼ʧ�ܣ�")
        }
    end

    def clearup
        operate("1 �ָ�Ĭ���˻�") {
            @account_page = RouterPageObject::AccountPage.new(@browser)
            rs            = @account_page.login_with_exists(@browser.url)
            if rs #�����ǰ�ǵ�¼���棬���ȵ�¼
                usrnames =[@tc_usr_new1, @tc_usr_new2, @tc_usr_new3]
                flag     =false
                usrnames.each do |usr|
                    @account_page.login_with(usr, @ts_default_pw, @browser.url) #���ʻ���¼
                    lan = @account_page.lan?
                    if lan
                        puts "�޸�ΪĬ���˻�!".to_gbk
                        @account_page.modify_account(@browser.url, @ts_default_usr, @ts_default_pw) #���˻���¼�ɹ����޸��˻�ΪĬ��
                        flag=true
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