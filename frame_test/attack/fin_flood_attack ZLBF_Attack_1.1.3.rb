#
#description:
#author:wuhongliang
#date:2016-06-03 14:12:41
#modify:
#
testcase {

		attr = {"id" => "ZLBF_Attack_1.1.3", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_delay = 2 #100pps
				@tc_count = 1000
		end

		def process

				operate("1 设置外网DHCP接入") {
						puts
						puts "ZLBF_Attack_1.1.3"
						puts
						assert(true)
				}


		end

		def clearup


		end

}
