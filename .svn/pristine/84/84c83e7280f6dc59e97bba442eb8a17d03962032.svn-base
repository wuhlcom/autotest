#encoding: utf-8
require 'watir-webdriver'
require 'page-object'

class BaiDu
  include PageObject
  url = "www.baidu.com"
  page_url(url)
  button(:baidu_click, id: "su")
  link(:hao123, href: "http://www.hao123.com")
  text_field(:sosuo, id: "kw")
end
@browser = Watir::Browser.new :ff, :profile => "default"

baidu = BaiDu.new(@browser, true)
baidu.sosuo="周杰伦"
p baidu.sosuo_element.fire_event("mousedown")
p baidu.sosuo_element.fire_event("mouseup")
p baidu.baidu_click_element.fire_event("click")

# baidu.baidu_click_element.fire_event("mousedown")
# baidu.hao123_element.fire_event("click")
# baidu.hao123_element.fire_event("mousedown")
# baidu.hao123_element.fire_event("mouseup")



