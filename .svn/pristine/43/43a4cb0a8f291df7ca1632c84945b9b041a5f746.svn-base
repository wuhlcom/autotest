#router login page tags
#login in router
#date:2016-02-24
#author:wuhongliang
require './router_tag_value'
module RouterPageObject

		module Login_Page
				include PageObject
				text_field(:username, name: @@ts_tag_aduser)
				text_field(:password, name: @@ts_tag_adpass)
				button(:login, id: @@ts_tag_sbm)
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

end

if __FILE__==$0
		url          = "192.168.100.1"
		usrname      = "admin"
		passwd       = "admin"
		@browser     = Watir::Browser.new :firefox
		login_router = RouterPageObject::LoginPage.new(@browser)
		login_router.navigate_to url
		login_router.login_with(usrname, passwd)
end