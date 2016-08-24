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
  page_url "www.baidu.com" #定义了该页面的url
  text_field "keyword", id: "kw" #元素的定位与命名方法1
  button(:check, :id => "su") #元素的定位与命名方法2
end

require 'watir-webdriver'
# require_relative 'baidu_page' # require默认加载lib下的，如果要加载其他文件夹的可以使用require_relative
class Test
  browser=Watir::Browser.new :firefox
  page= Baidu_Page.new(browser,true) #这里是page-object的初始化方法传送一个#browser的对象，若为true且该page类中page_url存在值，则初始化的同时通过browser
  #去访问page_url。也可以page= Baidu_Page.new(browser)，然后通过下方注释那种去访问#URL。
  #page.navigate_to 'www.baidu.com'
  page.keyword='sb'
  page.check
end