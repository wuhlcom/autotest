#encoding:utf-8
#router account manager
#author:wuhongliang
file_path1 =File.expand_path('../router_main_page', __FILE__)
require file_path1
module RouterPageObject
		module Account_Page
				include PageObject
				in_iframe(src: @@ts_tag_account_manage) do |frame|
						text_field(:usrname, id: @@ts_tag_aduser, frame: frame) #用户名
						text_field(:passwd, id: @@ts_tag_adpass, frame: frame) #密码
						text_field(:pwconfirm, id: @@ts_tag_adpass2, frame: frame) #确认密码
						button(:save_account, id: @@ts_tag_sbm, frame: frame) #保存
						paragraph(:error_msg, id: @@ts_tag_errormsg, frame: frame) #提示
						link(:close_account, class_name: @@ts_tag_aui_close, text: @@ts_tag_aui_clsignal)
				end
		end

		class AccountPage < MainPage
				include Account_Page
				#打开账户管理
				def open_account_page(url)
						# self.navigate_to url					
						self.refresh
						sleep 2
						5.times do
								break if dev_list? && !(dev_list_element.parent.em_element.text.nil?)
								self.refresh
								sleep 2
						end
						self.acount_config
						sleep 3
				end

				#关闭模式界面
				def close_account_page
						if self.close_account?
								self.close_account
								sleep 1
						end
				end

				#输入用户名
				def input_usr(usr)
						self.usrname_element.click
						self.usrname=usr
				end

				#输入密码
				def input_pw(pw)
						self.passwd_element.click
						self.passwd=pw
				end

				# 确认密码
				def input_confirmpw(pw)
						self.pwconfirm_element.click
						self.pwconfirm=pw
				end

				def set_pw(pw)
						input_pw(pw)
						input_confirmpw(pw)
				end

				def modify_account(url, usr, pw)
						open_account_page(url)
						input_usr(usr)
						set_pw(pw)
						save
				end

				def save
						save_account
						sleep 1
				end
		end

end