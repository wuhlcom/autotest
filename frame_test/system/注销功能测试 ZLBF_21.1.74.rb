#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
	attr = {"id" => "ZLBF_21.1.40", "level" => "P1", "auto" => "n"}

	def prepare
		# @tag_logout_id  = "logout"
		# @wait_time      = 5
		# @wait_for_logout= 5
	end

	def process

		operate("1 ��¼�豸") {
			# rs_login = login_recover(@browser, @ts_default_ip)
			# assert(rs_login, "·������¼ʧ�ܣ�")
				puts "ZLBF_21.1.40"
				puts
				assert(true)
		}

		operate("2 ע����¼") {
				assert(false,"����ʧ����")
		}

	end

	def clearup

	end

}
