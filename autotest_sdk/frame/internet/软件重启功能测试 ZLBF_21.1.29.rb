#
#description:
# ����̫�����ӣ�������������ʵ��
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_21.1.29", "level" => "P1", "auto" => "n"}

		def prepare

				@tc_wait_time         = 3
				@tc_relogin_time      = 60
				@tc_reboot_time       = 120
				@tc_tag_systemset     = "syssetting"
				@tc_tag_system_state  = "selected"
				@tc_tag_reboot_state  = "active"
				@tc_tag_adreboot      = "reboot-titile"
				@tc_tag_reboot_btn    = "reboot_submit_btn"
				@tc_tag_reboot_confirm= "aui_state_highlight"
		end

		def process

				operate("1 �ڿ�ݲ���ҳ������·����") {
						@browser.span(id: @ts_tag_reboot).click
						reboot_confirm = @browser.button(class_name: @ts_tag_reboot_confirm)
						assert reboot_confirm.exists?, "δ��ʾ����·����Ҫȷ��!"
						reboot_confirm.click

						#<div class="aui_content" style="padding: 20px 25px;">���������У����Ե�...</div>
						Watir::Wait.until(@tc_wait_time, "����·��������������ʾδ����") {
								@browser.div(:class_name, @ts_tag_rebooting).visible?
						}
						puts "Waitfing for system reboot...."
						sleep(@tc_reboot_time) #����������Ͽ����������������ʹ��sleep���ȴ�����������Watir::Wait���ȴ�
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
						assert rs, "����·����ʧ��δ��ת����¼ҳ��!"
				}

				operate("2 ʹ�ø߼����ý������������") {
						login_no_default_ip(@browser)
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "�򿪸߼�����ʧ��!")

						#ѡ��ϵͳ���á�
						sysset = @advance_iframe.link(id: @tc_tag_systemset).class_name
						unless sysset == @tc_tag_system_state
								@advance_iframe.link(id: @tc_tag_systemset).click
								sleep @tc_wait_time
						end

						#ѡ������·������
						system_reboot = @advance_iframe.link(id: @tc_tag_adreboot)
						reboot_state  = system_reboot.parent.class_name
						system_reboot.click unless reboot_state==@tc_tag_reboot_state

						#����·����
						@advance_iframe.button(id: @tc_tag_reboot_btn).click

						reboot_confirm = @advance_iframe.button(class_name: @ts_tag_reboot_confirm)
						assert reboot_confirm.exists?, "δ��ʾ����·����Ҫȷ��!"
						#ȷ������
						reboot_confirm.click

						#<div class="aui_content" style="padding: 20px 25px;">���������У����Ե�...</div>
						# Watir::Wait.until(@tc_wait_time, "����·��������������ʾδ����") {
						# 	@advance_iframe.div(:class_name, @ts_tag_rebooting).visible?
						# }
						puts "Waitfing for system reboot...."
						sleep(@tc_reboot_time) #����������Ͽ����������������ʹ��sleep���ȴ�����������Watir::Wait���ȴ�
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
						assert rs, "����·������δ��ת����¼ҳ��!"
				}
		end

		def clearup

		end

}
