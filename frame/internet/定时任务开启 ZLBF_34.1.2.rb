#
# description:
# author:liluping
# date:2015-09-28
# modify:
#
testcase {
    attr = {"id" => "ZLBF_34.1.2", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_wait_time = 3
        @tc_ping_num  = 100
    end

    def process

        operate("1����¼AP�����뵽��ʱ����ҳ��") {
            @options_page = RouterPageObject::OptionsPage.new(@browser)
        }

        operate("2������һ����ʱʱ�䣬��������Ϊ��ǰʱ�����һ���ӣ�Ȼ������ʱ���񣬵�����档") {
            @options_page.restart_step(@browser.url)
        }

        operate("3���鿴ʱ�䵽��·�����Ƿ�����") {
            sleep @tc_wait_time
            #����ping 192.168.100.1���鿴������
            lost_pack = ping_lost_pack(@default_url, @tc_ping_num)
            if lost_pack >= 5 && lost_pack <= 30
                lost_flag = true
            else
                lost_flag = false
            end
            assert(lost_flag, "100�����ж�ʧ#{lost_pack}�����������趨����[5,30],�ж�Ϊ�������ɹ���")
        }


    end

    def clearup
        operate("1.���ƻ�����ʱ�����") {
            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.clear_all_time(@browser.url)
        }
    end

}
