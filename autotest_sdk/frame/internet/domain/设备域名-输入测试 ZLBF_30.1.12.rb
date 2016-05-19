#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_30.1.12", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_domain_error_tip = "����ֻ������ĸ�����֡��»��ߡ��л���"
				@tc_cn_domain        = "·����"
				@tc_error_domain     = "Router@"
				@tc_error_domain1    = "zhi"
		end

		def process

				operate("1��AP��������������Ϊ·��ģʽ��") {
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "�򿪸߼�����ʧ�ܣ�")
				}

				operate("2�����뵽�豸���������������ģ��й��ˣ��鿴�Ƿ��ܹ����棻") {
						#���ϵͳ����
						@advance_iframe.link(id: @ts_tag_op_system).click
						#�����������
						@advance_iframe.link(id: @ts_tag_domain).click
						#��������
						p "��������Ϊ��#{@tc_cn_domain}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_domain_field).set(@tc_cn_domain)
						@advance_iframe.button(id: @ts_tag_sbm).click
						error_tip      = @advance_iframe.p(id: @ts_tag_domain_err)
						assert(error_tip.exists?,"δ��������������ʾ")
						error_tip_info = error_tip.text
						p "������ʾ:#{error_tip}".encode("GBK")
						assert_equal(@tc_domain_error_tip,error_tip_info,"����������ʾ���ݲ���ȷ!")
				}

				operate("3�����豸���������������ַ���~!@#$%^&*()���鿴�Ƿ��ܹ����棻") {
						p "��������Ϊ��#{@tc_error_domain}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_domain_field).set(@tc_error_domain)
						@advance_iframe.button(id: @ts_tag_sbm).click
						error_tip      = @advance_iframe.p(id: @ts_tag_domain_err)
						assert(error_tip.exists?,"δ��������������ʾ")
						error_tip_info = error_tip.text
						p "������ʾ:#{error_tip}".encode("GBK")
						assert_equal(@tc_domain_error_tip,error_tip_info,"����������ʾ���ݲ���ȷ!")
				}

				operate("4�����豸����������û��.cn/.com/.net�鿴�Ƿ��ܹ����档") {
						p "��������Ϊ��#{@tc_error_domain}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_domain_field).set(@tc_error_domain1)
						@advance_iframe.button(id: @ts_tag_sbm).click
						error_tip      = @advance_iframe.p(id: @ts_tag_domain_err)
						assert(error_tip.exists?,"δ��������������ʾ")
						error_tip_info = error_tip.text
						p "������ʾ:#{error_tip}".encode("GBK")
						assert_equal(@tc_domain_error_tip,error_tip_info,"����������ʾ���ݲ���ȷ!")
				}


		end

		def clearup

		end

}
