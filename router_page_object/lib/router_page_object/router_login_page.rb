#encoding:utf-8
#router login page tags
#login in router
#date:2016-02-24
#author:wuhongliang
file_path1 =File.expand_path('../router_tag_value', __FILE__)
require file_path1
module RouterPageObject

		module Login_Page
				include PageObject
				text_field(:username, name: @@ts_tag_aduser)
				text_field(:password, name: @@ts_tag_adpass)
				button(:login, id: @@ts_tag_sbm)
				div(:main_error, class_name: @@ts_tag_login_error)
		end

		class LoginPage
				include Login_Page

				def login_with(username, password, url)
						self.navigate_to url
						sleep 2
						self.username = username
						self.password = password
						self.login
						sleep 2
				end

				#判断登录界面是否存在
				def login_with_exists(url)
						# self.navigate_to url
						# sleep 1
						username_element.exists?
				end
		end

end

