#encoding:utf-8
#统计 自动化脚本统计表 中的已经实现的脚本数量并取出脚本名字保存在数组中
#数组中保存的脚本名为GBK编码
#再将脚本名字排序后保存到txt中
require 'win32ole'
require 'pp'
#返回一张表中tc名
def get_tc(worksheet, linenum, key="pass")
		line        = '1'
		tc_name_arr = []
		i           = 1
		while i<=linenum
				if worksheet.Range("B#{line}").Value=~/#{key}/i #如果B列的内容为pass就取出A列的内容,A列的内容是脚本名
						tc_name = worksheet.Range("A#{line}").Value
						if tc_name.nil?||tc_name.empty?
								puts "empty"
								break
						end
						tc_name_arr << tc_name
				end
				line.succ!
				i+=1
		end
		{tc_num: tc_name_arr.size, tc_name_arr: tc_name_arr}
end

begin
		file_path = "E:/自动化/脚本开发统计/自动化脚本开发统计汇总统一平台.xlsx"
		excel     = WIN32OLE::new('excel.Application')
		workbook  =excel.Workbooks.Open(file_path)
		worksheet =workbook.Worksheets(1) #定位到第一个sheet
		worksheet.Select
		excel_tc    = File.new("d:/excel_tc_statistics.txt", "w")
		# 将第一张表中的的值读入到一个数组中
		# 这里读出的用例名称都是GBK编码
		rs1         = get_tc(worksheet, 100)
		# 将第二张表中的的值读入到一个数组中
		worksheet2  =workbook.Worksheets(2) #定位到第二个sheet
		rs2         =get_tc(worksheet2, 200)
		# 将第三张表中的的值读入到一个数组中
		worksheet3  =workbook.Worksheets(3) #定位到第三个sheet
		rs3         =get_tc(worksheet3, 200)
		# 将第四张表中的的值读入到一个数组中
		worksheet4  =workbook.Worksheets(4) #定位到第四个sheet
		rs4         =get_tc(worksheet4, 200)
		# 将第四张表中的的值读入到一个数组中
		worksheet5  =workbook.Worksheets(5) #定位到第五个sheet
		rs5         =get_tc(worksheet5, 200)
		#合并两个数组
		tc_name_arr = rs1[:tc_name_arr]+rs2[:tc_name_arr]+rs3[:tc_name_arr]+rs4[:tc_name_arr]+rs5[:tc_name_arr]
		#将用例名保存在txt文件中，GBK字符串排序
		tc_name_arr.sort.each do |tc| #保存所有脚本名到文件
				excel_tc.puts tc
		end
rescue => ex
		puts ex
ensure
		excel.Quit
		excel_tc.close
end