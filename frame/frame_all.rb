require './parser_frame_xml'
t1        = Time.now()
curr_path = File.dirname(File.expand_path(__FILE__))
begin
		xml_all        = "frame_all.xml"
		xml_obj        = TestTool::XML.new(xml_all)
		statistics     = xml_obj.statistics_testcase
		file_tc_autoy  = File.new("d:/tc_autoy.txt", "w")
		#这里保存的用例名都是Unicode编码utf-8编码
		auto_y_arr     = statistics[:auto_y]
		auto_y_new_arr = []
		#将数组元素转码为GBK
		auto_y_arr.each { |tc|
				auto_y_new_arr<< tc.encode("GBK")
		}
		#保存用例名到文件
		auto_y_new_arr.sort.each { |tc|
				file_tc_autoy.puts tc
		}
		file_tc_autoy.puts "=="*20
		file_tc_autoy.puts "testcase auto attribute value is 'y' num:#{statistics[:auto_y_num]}"
		file_tc_autoy.puts "testcase auto attribute value is 'n' num:#{statistics[:auto_n_num]}"
rescue => ex
		p ex.message.to_s
ensure
		file_tc_autoy.close unless file_tc_autoy.nil?
		load "#{curr_path}/frame_internet.rb"
		load "#{curr_path}/frame_system.rb"
		load "#{curr_path}/frame_backup.rb"
		load "#{curr_path}/frame_reset.rb"
		load "#{curr_path}/frame_apmode.rb"
end