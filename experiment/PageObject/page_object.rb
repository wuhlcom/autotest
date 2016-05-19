# class LoginPage
#   include PageObject
#   page_url "www.baidu.com"
#   text_field(:username, :id => 'user')
#   text_field(:password, :id => 'pass')
#   button(:login, :value => 'Login')
# end
# browser = Watir::Browser.new :firefox
# login_page = LoginPage.new(browser)
# login_page.username = 'cheezy'
# login_page.password = 'secret'
# login_page.login

require 'Page-Object'
class Baidu_Page
  include PageObject
  page_url "www.baidu.com" #�����˸�ҳ���url
  text_field "keyword", id: "kw" #Ԫ�صĶ�λ����������1
  button(:check, :id => "su") #Ԫ�صĶ�λ����������2
end

require 'watir-webdriver'
# require_relative 'baidu_page' # requireĬ�ϼ���lib�µģ����Ҫ���������ļ��еĿ���ʹ��require_relative
class Test
  browser=Watir::Browser.new :firefox
  page= Baidu_Page.new(browser,true) #������page-object�ĳ�ʼ����������һ��#browser�Ķ�����Ϊtrue�Ҹ�page����page_url����ֵ�����ʼ����ͬʱͨ��browser
  #ȥ����page_url��Ҳ����page= Baidu_Page.new(browser)��Ȼ��ͨ���·�ע������ȥ����#URL��
  #page.navigate_to 'www.baidu.com'
  page.keyword='sb'
  page.check
end