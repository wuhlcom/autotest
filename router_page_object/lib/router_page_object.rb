#encoding:utf-8
require 'page-object'
module RouterPageObject
		libs = Dir.glob(File.expand_path(File.dirname(__FILE__))+"/router_page_object/*")
		libs.each { |lib|
				next unless File.extname(lib)==".rb"
				require lib
		}
end




