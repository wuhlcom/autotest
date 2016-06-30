#
# description:
# 特殊字符:空格,"@",".","-"
# author:wuhongliang
# date:2015-10-%qos 17:43:16
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.14", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_lan_time          = 35
				@tc_operate_time      = 1
				@tc_error_no_startip  = "请输入DHCP开始地址"
				@tc_error_no_endip    = "请输入DHCP结束地址"
				@tc_error_not_same_seg= "DHCP地址和局域网IP不在同一网段"
				@tc_error_ip_format   = "DHCP地址格式有误"
				@tc_addr_special0     = ""
				@tc_addr_special1     = " "
				@tc_addr_special2     = "@"
				@tc_addr_special3     = "."
				@tc_addr_special4     = "\/"
		end

		def process

				operate("1、登陆路由器进入内网设置") {
						@lan_page = RouterPageObject::LanPage.new(@browser)
						@lan_page.open_lan_page(@browser.url)
				}

				operate("2、更改DHCP地址池输入特殊字符；") {
						@tc_lan_start_pre = @lan_page.lan_startip_pre
						@tc_lan_start     = @lan_page.lan_startip
						@tc_lan_startip   = @tc_lan_start_pre+@tc_lan_start

						@tc_lan_end_pre = @lan_page.lan_endip_pre
						@tc_lan_end     = @lan_page.lan_endip
						@tc_lan_endip   = @tc_lan_end_pre+@tc_lan_end

						puts "Current LAN DHCP Server pool start ip:#{@tc_lan_startip}"
						puts "Current LAN DHCP Server pool end ip:#{@tc_lan_endip}"
						#######################special1#########
						puts "不输入地址".encode("GBK")
						puts "不输入地址起始IP".encode("GBK")
						@lan_page.lan_startip_set(@tc_addr_special0)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@tc_error_no_startip
								assert_equal(@tc_error_no_startip, @lan_page.lan_error.strip, "地址池起始不输入提示错误")
						else
								sleep @tc_lan_time
								assert(false, "地址池起始地址不输入未提示出错")
						end
						sleep @tc_operate_time
						puts "不输入地址结束IP".encode("GBK")
						@lan_page.lan_startip_set(@tc_lan_start)
						@lan_page.lan_endip_set(@tc_addr_special0)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@tc_error_no_endip
								assert_equal(@tc_error_no_endip, @lan_page.lan_error.strip, "地址池结束地址不输入提示错误")
						else
								sleep @tc_lan_time
								assert(false, "地址池结束地址不输入未提示出错")
						end
						sleep @tc_operate_time
						#######################special1#########
						puts "地址输入空格".encode("GBK")
						puts "修改起始IP为空格".encode("GBK")
						@lan_page.lan_startip_set(@tc_addr_special1)
						@lan_page.lan_endip_set(@tc_lan_end)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@ts_lanip_err
								assert_equal(@ts_lanip_err, @lan_page.lan_error.strip, "地址池起始地址空格提示错误")
						else
								sleep @tc_lan_time
								assert(false, "地址池起始地址输入空格未提示出错")
						end
						sleep @tc_operate_time
						puts "修改结束IP为空格".encode("GBK")
						@lan_page.lan_startip_set(@tc_lan_start)
						@lan_page.lan_endip_set(@tc_addr_special1)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@ts_lanip_err
								assert_equal(@ts_lanip_err, @lan_page.lan_error.strip, "地址池结束地址输入空格提示错误")
						else
								sleep @tc_lan_time
								assert(false, "地址池结束地址输入空格未提示出错")
						end
						sleep @tc_operate_time
						############################special2######################
						puts "地址输入特殊字符'#{@tc_addr_special2}'".encode("GBK")
						puts "修改起始IP为：'#{@tc_addr_special2}'".encode("GBK")
						@lan_page.lan_startip_set(@tc_addr_special2)
						@lan_page.lan_endip_set(@tc_lan_end)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@ts_lanip_err
								assert_equal(@ts_lanip_err, @lan_page.lan_error.strip, "地址池起始地址输入特殊字符'#{@tc_addr_special2}'提示错误")
						else
								sleep @tc_lan_time
								assert(false, "地址池起始地址输入特殊字符'#{@tc_addr_special2}'未提示出错")
						end
						sleep @tc_operate_time
						puts "修改结束IP为：'#{@tc_addr_special2}'".encode("GBK")
						@lan_page.lan_startip_set(@tc_lan_start)
						@lan_page.lan_endip_set(@tc_addr_special2)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@ts_lanip_err
								assert_equal(@ts_lanip_err, @lan_page.lan_error.strip, "地址池结束地址输入特殊字符'#{@tc_addr_special2}'提示错误")
						else
								sleep @tc_lan_time
								assert(false, "地址池结束地址输入特殊字符'#{@tc_addr_special2}'未提示出错")
						end
						sleep @tc_operate_time
						############################special3######################
						puts "地址输入特殊字符'#{@tc_addr_special3}'".encode("GBK")
						puts "修改起始IP为：'#{@tc_addr_special3}'".encode("GBK")
						@lan_page.lan_startip_set(@tc_addr_special3)
						@lan_page.lan_endip_set(@tc_lan_end)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@ts_lanip_err
								assert_equal(@ts_lanip_err, @lan_page.lan_error.strip, "地址池起始地址输入特殊字符'#{@tc_addr_special3}'提示错误")
						else
								sleep @tc_lan_time
								assert(false, "地址池起始地址输入特殊字符'#{@tc_addr_special3}'未提示出错")
						end
						sleep @tc_operate_time
						puts "修改结束IP为：'#{@tc_addr_special3}'".encode("GBK")
						@lan_page.lan_startip_set(@tc_lan_start)
						@lan_page.lan_endip_set(@tc_addr_special3)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@ts_lanip_err
								assert_equal(@ts_lanip_err, @lan_page.lan_error.strip, "地址池结束地址输入特殊字符'#{@tc_addr_special3}'提示错误")
						else
								sleep @tc_lan_time
								assert(false, "地址池结束地址输入特殊字符'#{@tc_addr_special3}'未提示出错")
						end
						sleep @tc_operate_time
						############################special4######################
						puts "地址输入特殊字符'#{@tc_addr_special4}'".encode("GBK")
						puts "修改起始IP为：'#{@tc_addr_special4}'".encode("GBK")
						@lan_page.lan_startip_set(@tc_addr_special4)
						@lan_page.lan_endip_set(@tc_lan_end)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@ts_lanip_err
								assert_equal(@ts_lanip_err, @lan_page.lan_error.strip, "地址池起始地址输入特殊字符'#{@tc_addr_special4}'提示错误")
						else
								sleep @tc_lan_time
								assert(false, "地址池起始地址输入特殊字符'#{@tc_addr_special4}'未提示出错")
						end
						sleep @tc_operate_time
						puts "修改结束IP为：'#{@tc_addr_special4}'".encode("GBK")
						@lan_page.lan_startip_set(@tc_lan_start)
						@lan_page.lan_endip_set(@tc_addr_special4)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@ts_lanip_err
								assert_equal(@ts_lanip_err, @lan_page.lan_error.strip, "地址池结束地址输入特殊字符'#{@tc_addr_special4}'提示错误")
						else
								sleep @tc_lan_time
								assert(false, "地址池结束地址输入特殊字符'#{@tc_addr_special4}'未提示出错")
						end
						sleep @tc_operate_time
				}

				operate("3、点击保存") {
						#上一步已完成此操作
				}


		end

		def clearup
				operate("1 恢复默认起始地址范围") {
						@browser.refresh
						@lan_page = RouterPageObject::LanPage.new(@browser)
						@lan_page.open_lan_page(@browser.url)
						tc_lan_start = @lan_page.lan_startip
						tc_lan_end   = @lan_page.lan_endip
						flag         = false
						#恢复默认起始地址
						unless (!@tc_lan_start.nil? && tc_lan_start == @tc_lan_start)
								puts "恢复默认起始地址".to_gbk
								@lan_page.lan_startip_set(@tc_lan_start)
								flag= true
						end

						#恢复默认结束地址
						unless (!@tc_lan_end.nil? && tc_lan_end == @tc_lan_end)
								puts "恢复默认结束地址".to_gbk
								@lan_page.lan_endip_set(@tc_lan_end)
								flag= true
						end

						if flag
								@lan_page.btn_save_lanset
						end
				}
		end

}
