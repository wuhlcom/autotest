#
#description:
#author:wuhongliang
#date:2016-06-03 14:12:41
#modify:
#
testcase {

		attr = {"id" => "ZLBF_Attack_1.1.1", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_delay= 10 ##每秒50个报文
				@tc_count= 1000
		end

		def process

				operate("1 设置外网DHCP接入") {
						puts
						puts "ZLBF_Attack_1.1.2"
						puts
						assert(true)
						# @wan_page = RouterPageObject::WanPage.new(@browser)
						# puts "设置接入方式为DHCP".to_gbk
						# @wan_page.set_dhcp(@browser, @browser.url)
				}

		end

		def clearup


		end

}
