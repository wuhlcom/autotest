#
#description:ÿ��1������
#author:wuhongliang
#date:2016-06-03 14:12:41
#modify:
#
testcase {

		attr = {"id" => "ZLBF_Attack_1.1.1", "level" => "P1", "auto" => "n"}

		def prepare

		end

		def process

				operate("1 ��������DHCP����") {
						puts
						puts "ZLBF_Attack_1.1.1"
						puts
						assert(true)
				}

		end

		def clearup


		end

}
