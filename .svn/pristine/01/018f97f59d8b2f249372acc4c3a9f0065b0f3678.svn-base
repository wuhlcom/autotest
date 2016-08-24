#encoding:utf-8
require 'watir-webdriver'
module HtmlTag
		module ScreenShot
				def get_screenshot(browser)
						browser.screenshot
				end

				#img_path,"d:/xxx.jpg","d:/xxx.png","d:/xxx.bmp"
				def save_screenshot(browser, img_path, time = Time.new.strftime("%Y%m%d%H%M%S"))
						puts "screen shot begin..."
						extname = File.extname(img_path)
						unless extname=~/\.[jpg|png|bmp]/i
								fail "Image type error"
						end
						dirname = File.dirname(img_path)
						FileUtils.mkdir_p(dirname) unless File.exists?(dirname)
						screen   = get_screenshot(browser)
						index    = img_path.index(/\.\w+$/) #取出文件名后缀,.xx中.对应的索引值
						new_path = img_path.insert(index, "_#{time}") #在文件名后缀前插入时间形成新的文件名
						screen.save(new_path)
				end
		end
end


if $0==__FILE__
		class OpenWeb
				attr_accessor :browser

				def initialize(url, driver=:ie, profile="default")
						case driver
								when :ie
										@browser =Watir::Browser.new(driver)
								when :ff, :firefox
										@browser =Watir::Browser.new(driver, :profile => profile)
						end
						@browser.goto(url)
				end

				def close
						@browser.close
				end

		end
		class TestScreenshot<OpenWeb
				include HtmlTag::ScreenShot
		end

		url     = "www.sohu.com"
		path    = "sohu.png"
		testobj = TestScreenshot.new(url)
		testobj.save_screenshot(testobj.browser, path)
		testobj.close
end

