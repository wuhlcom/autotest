require 'page-object'
module PageObject
	 	@@ts_name = 'admuser'
end

module Login_Page
		include PageObject
		text_field(:username, name: @@ts_name)
		text_field(:password, name: 'admpass')
		button(:login, id: 'submit_btn')
end

module Main_Page
		include PageObject
		span(:set_network, id: "set_network")
end

module WAN_Page
		include PageObject
		in_iframe(src: 'netset.asp') do |frame|
				span(:wire, id: 'wire', frame: frame)
				span(:wireless, id: 'wireless', frame: frame)
				span(:dial, id: 'dial', frame: frame)
				radio(:dhcp, id: "ip_type_dhcp", frame: frame)
				radio(:pppoe, id: "ip_type_pppoe", frame: frame)
				radio(:static, id: "ip_type_static", frame: frame)
				text_field(:pppoeusr, id: 'pppoeUser', frame: frame)
				text_field(:pppoepw, id: 'input_password1', frame: frame)
				button(:savepppoe, id: 'submit_btn', frame: frame)
				text_field(:static_ip, id: 'StaticIP', frame: frame)
				text_field(:static_mask, id: 'input_password1', frame: frame)
				text_field(:static_gw, id: 'pppoeUser', frame: frame)
				text_field(:static_dns, id: 'input_password1', frame: frame)
				button(:savepppoe, id: 'submit_btn', frame: frame)
		end
end

class LoginPage

		include Login_Page

		def login_with(username, password)
				self.username = username
				self.password = password
				self.login
				sleep 1
		end
end

class MainPage < LoginPage
		include Main_Page

		def wan_span_obj
				set_network_element
		end
end

class WANPage<MainPage
		include WAN_Page

		def wire_span_obj
				wire_element
		end

		def wireless_span_obj
				wireless_element
		end

		def dial_span_obj
				dial_element
		end

		def dhcp_radio_obj
				dhcp_element
		end

		def pppoe_radio_obj
				pppoe_element
		end

		def static_radio_obj
				static_element
		end

		def pppoe(usr, pw)
				self.wan_span_obj.click
				self.wire_span_obj.click
				self.pppoe_radio_obj.click
				self.pppoeusr=usr
				self.pppoepw =pw
				self.savepppoe
		end
end


usrname  = "admin"
passwd   = "admin"
pppoeusr = "pppoe"
pppoepw  = "pppoe"
url      = "192.168.100.1"
@browser = Watir::Browser.new :firefox
login_router = LoginPage.new(@browser)
login_router.navigate_to url
login_router.login_with(usrname, passwd)
p login_router.current_url
p login_router.browser
##################################################
# main_page = MainPage.new(@browser)
# main_page.navigate_to url
# main_page.login_with(usrname, passwd)
# p @browser.url
# main_page.navigate_to @browser.url
# main_page.set_network_element.click
#############################################################
# wan_page = WANPage.new(@browser)
# wan_page.navigate_to url
# wan_page.login_with(usrname, passwd)
# p @browser.url
# wan_page.navigate_to @browser.url
# wan_page.pppoe(pppoeusr, pppoepw)
################################################################
# pppoe_page = PPPOE_ACCESS.new(@browser)
# pppoe_page.navigate_to url
# pppoe_page.login_with(usrname, passwd)
# p @browser.url
# pppoe_page.navigate_to @browser.url
# # pppoe_page.wan_span_obj.click
# # wan_page.wire_span_obj.click
# # p wan_page.dhcp_radio_obj.click
# pppoe_page.pppoe(pppoeusr, pppoepw)
