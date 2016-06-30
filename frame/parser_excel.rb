#encoding: utf-8
# 操作excel文件的几个重要元素
# Excel =>workbook => worksheet => range(cell)
# 我理解的是excel为类名,workbook为一个具体的(excel文件)实例,创建好实例后,worksheet是实例(workbook,工作簿)中的一个工作表,然后可
# 以对工作表中的每个单元格(range(cell))进行具体的读写
#
# 解析测试用例，将用例名，ID,级别，步骤等解析到Hash组
# 获取用例名，ID,level
# author : wuhongliang
# date   : 2015-7-15
require 'win32ole'
module TestTool
		class Excel
				attr_accessor :testcase_hash
				# excel.visible = true    # in case you want to see what happens
				def initialize(file, flag = false, sheet_index=1)
						@worksheet     = nil
						@workbook      = nil
						@range         = nil
						@testcase_hash ={}
						@file          = file
						fail "File path error!" unless File.exists?(@file)
						@sheet_index   = sheet_index.to_i
						@excel         = WIN32OLE::new('excel.Application')
						@excel.visible = flag
				end

				#打开workbook
				def workbook
						@workbook =@excel.workbooks.open(@file)
				end

				#选择sheet
				def worksheet_select(index=@sheet_index)
						@worksheet=@workbook.worksheets(index.to_i) #定位一个sheet
						@worksheet.select
						@worksheet
				end

				def worksheet(index=@sheet_index)
						workbook
						worksheet_select(index.to_i)
				end

				#单元格或行，列对象
				#params
				# -args,	string,"A1","a1:a3"
				#samples
				# obj.rangeobj("a1:a3")
				def range_select(args)
						@range = @worksheet.range(args)
				end

				def range(args)
						index =args[:index] if args[:index].nil?
						range = args[:range]
						worksheet(index)
						range_select(range)
				end

				# worksheet.Range('a12')['Value']  #读取a12中的数据
				# data =worksheet.Range('a1:c12')['Value'] #将数据读入到一个二维表
				def get_range()
						@range.value
				end

				#设置单元格，行，列的值
				#params
				# -args,string;"11"
				#samples
				# worksheet.Range('e2')['Value']= Time.now.strftime '%d/%m/%Y' #单个值
				# worksheet.Range('a5:c5')['Value'] = ['Test', '25', 'result'] #将一个数组写入
				# obj.set_range("11")
				def set_range(args)
						@range.value = args
				end

				# workbook.SaveAs'myfile.xls'
				def saveas_workbook(file)
						file_path = file.gsub("\/", "\\\\")
						if @workbook.nil?
								fail "excel workbook obj is nil"
						else
								@workbook.saveas(file_path)
						end
				end

				# workbook.close#关闭
				def close_workbook
						@workbook.close
				end

				# excel.Close#关闭
				def close_excel
						@excel.quit
				end

				# 调用宏定义
				# excel.Run('SortByNumber')
				def run_macro(macro)
						@excel.run('SortByNumber')
				end

				# 设置背景色
				# worksheet.Range('a3:f5').Interior['ColorIndex']= 36 #pale yellow
				# # 将背景色恢复成无色
				# worksheet.Range('a3:f5').Interior['ColorIndex']= -4142 # XlColorIndexNone constant
				# # 使用Excelconstant 将背景色恢复成无色
				# worksheet.Range('a3:f5').Interior['ColorIndex']= ExcelConst::XlColorIndexNone
				def set_color(color)
						@range.Interior['ColorIndex']=color
				end

				#获取一列数据
				def get_col(args)
						args[:raw]         = "a" if args[:raw].nil?
						raw                = args[:raw]
						args[:col]         = "1" if args[:col].nil?
						col                = args[:col]

						args[:sheet_index] = @sheet_index if args[:sheet_index].nil?
						sheet_index        = args[:sheet_index]
						worksheetobj       = worksheet(sheet_index)

						data = []
						while col_value=worksheetobj.range("#{raw}#{col}").value
								data << col_value
								col.succ!
						end
						data
				end

				#获取一列数据
				def get_raw(args)
						args[:raw]         = "a" if args[:raw].nil?
						raw                = args[:raw]
						args[:col]         = "1" if args[:col].nil?
						col                = args[:col]

						args[:sheet_index] = @sheet_index if args[:sheet_index].nil?
						sheet_index        = args[:sheet_index]
						worksheetobj       = worksheet(sheet_index)

						data = []
						while worksheetobj.range("#{raw}#{col}").value
								data << worksheetobj.range("#{raw}#{col}").value
								raw.succ!
						end
						data
				end

				#获取满足某一条件的列的值
				#比如当G列每行的值为“三期”时，C列的值
				def get_value_by_condition(args)
						#条件列
						condition_col      = args[:condition_col]
						#目标列
						target_col         = args[:target_col]
						#条件值
						condition          = args[:condition]
						#查找多少行
						lines              = args[:lines]
						#选择 表单
						args[:sheet_index] = @sheet_index if args[:sheet_index].nil?
						sheet_index        = args[:sheet_index]
						worksheetobj       = worksheet(sheet_index)

						data        = []
						args[:line] = "1" if args[:line].nil?
						line        = args[:line] #起始行
						while line.to_i <= lines.to_i
								#条件
								if worksheetobj.range("#{condition_col}#{line}").value=~/#{condition}/
										data << worksheetobj.range("#{target_col}#{line}").value
								end
								line.succ!
						end
						data
				end

				#获取用例名，ID，级别
				def get_name_id_level(args)
						#条件列
						condition_col      = args[:condition_col]
						#条件值
						condition          = args[:condition]
						#name列
						name_col           = args[:name_col]
						id_col             = args[:id_col] #ID列数组，[旧，新]
						level_col          = args[:level_col]
						#查找多少行
						lines              = args[:lines]
						#选择 表单
						args[:sheet_index] = @sheet_index if args[:sheet_index].nil?
						sheet_index        = args[:sheet_index]
						worksheetobj       = worksheet(sheet_index)
						tc_hash            ={}
						id                 =""
						args[:line]        = "1" if args[:line].nil?
						line               = args[:line] #起始行
						while line.to_i <= lines.to_i
								if worksheetobj.range("#{condition_col}#{line}").value=~/#{condition}/
										next if worksheetobj.range("#{name_col}#{line}").value.nil?||worksheetobj.range("#{name_col}#{line}").value.empty?
										if id_col.size>1
												#处理新ID和旧ID例，有新ID使用新ID，无新ID使用旧ID
												id_col.each_index do |idx|
														num         = id_col.size-idx-1
														testcase_id = worksheetobj.range("#{id_col[num]}#{line}").value
														unless testcase_id.nil?||testcase_id.empty?
																id = testcase_id.encode("utf-8") #转成utf-8，否则保存到文件中会成为乱码
																break
														end
												end
										else
												if id_col.kind_of?(Array)
														id_raw_value = id_col[0]
												end
												id = worksheetobj.range("#{id_raw_value}#{line}").value
												id = id.encode("utf-8") unless id.nil? #转成utf-8，否则保存到文件中会成为乱码
										end

										name            = worksheetobj.range("#{name_col}#{line}").value
										name            = name.encode("utf-8") unless name.nil? #转成utf-8，否则保存到文件中会成为乱码
										tc_name         = name.sub(/\/|\\/, "_")
										level           = worksheetobj.range("#{level_col}#{line}").value
										level           = level.encode("utf-8") unless level.nil? #转成utf-8，否则保存到文件中会成为乱码
										#{tcname=>{"id"=>xxx,"level"=>xxx,"path"=>xxx}
										tc_hash[tc_name]={"id" => id, "level" => level}
								end
								line.succ!
						end
						tc_hash
				end

				#生成测试用例名字，级别，ID，步骤等Hash组
				def create_tcname(args)
						#ID列
						args[:id_col]        = "D" if args[:id_col].nil?
						id_col               = args[:id_col]
						#起始行号
						args[:line]          = "1" if args[:line].nil?
						line                 = args[:line]
						#最大行号
						args[:lines]         = "300" if args[:lines].nil?
						lines                = args[:lines]
						#用例名称列
						args[:name_col]      = "c" if args[:name_col].nil?
						name_col             = args[:name_col]
						#用例级别列
						args[:level_col]     = "e" if args[:level_col].nil?
						level_col            = args[:level_col]

						args[:condition_col] = "f" if args[:condition_col].nil?
						condition_col        = args[:condition_col]
						condition            = args[:condition]

						args[:tc_path]       = "" if args[:tc_path].nil?
						tc_path              = args[:tc_path]

						args[:sheet_index]   = @sheet_index if args[:sheet_index].nil?
						sheet_index          = args[:sheet_index]
						worksheetobj         = worksheet(sheet_index)

						args[:auto]          = "n" if args[:auto].nil?
						flag                 = args[:auto]

						#测试步骤
						args[:step_col]      = "j" if args[:step_col].nil?
						step_col             = args[:step_col]
						id                   = ""
						testcases            =[]
						id_col_num           = id_col.size
						while line.to_i <= lines.to_i
								begin
										condition_value = worksheetobj.range("#{condition_col}#{line}").value
										if condition_value =~ /#{condition}/
												#处理新ID和旧ID例，有新ID使用新ID，无新ID使用旧ID
												if id_col_num>1
														id_col.each_index do |idx|
																num         = id_col_num-idx-1
																testcase_id = worksheetobj.range("#{id_col[num]}#{line}").value
																unless testcase_id.nil?
																		id = testcase_id.encode("utf-8") #转成utf-8，否则保存到文件中会成为乱码
																		break
																end
														end
												else
														if id_col.kind_of?(Array)
																id_raw_value = id_col[0]
														end
														id = worksheetobj.range("#{id_raw_value}#{line}").value
														id = id.encode("utf-8") unless id.nil? #转成utf-8，否则保存到文件中会成为乱码
												end
												name    = worksheetobj.range("#{name_col}#{line}").value
												name    = name.encode("utf-8") unless name.nil? #转成utf-8，否则保存到文件中会成为乱码
												tc_name = name.sub(/\/|\\/, "_")
												level   = worksheetobj.range("#{level_col}#{line}").value
												level   = level.encode("utf-8") unless level.nil? #转成utf-8，否则保存到文件中会成为乱码
												#如果ID不为空，用例名称就使用用例名+ID组成,如果ID没有值则只使用用例名称
												if !id.nil? && id !=""
														tc_name = (tc_name+" "+id)
												end
												#读取用例步骤
												steps                  = worksheetobj.range("#{step_col}#{line}").value
												level                  = level.encode("utf-8") unless level.nil? #转成utf-8，否则保存到文件中会成为乱码
												#{tcname=>{"id"=>xxx,"level"=>xxx,"path"=>xxx,"steps"=>xxx}}
												@testcase_hash[tc_name]={"id" => id, "level" => level, "path" => tc_path, "auto" => flag, "steps" => steps}
												testcases<<tc_name
										end
										line.succ!
								rescue => ex
										print ex.backtrace.join("\n")
										puts ex.message.to_s
										line.succ!
								end
						end
						testcases
				end

		end

end

if $0==__FILE__
		require 'pp'
# 	file_name="V100R003版本自动化测试用例.xls"
# 	file_name="基线用例_V1.0.4_2015.8.24.xls"
# 		file_name="基线用例_V1.0.7_2015.10.29_带三期.xls"
		file_name="E:/工作管理/基线用例_V1.0.7_2015.10.29.xls"
		begin
				# puts exel_file = File.expand_path("../../../#{file_name}", __FILE__)
				excelobj =TestTool::Excel.new(file_name)
				###############################根据excel生成用例信息
				args     ={
						:condition     => "一期|二期|三期".encode("GBK"), #转成gbk
						:condition_col => "G",
						:id_col        => ["D", "E"],
						:line          => "3",
						:level_col     => "F",
						:lines         => "200",
						:sheet_index   => 1,
						:tc_path       => File.dirname(__FILE__)
				}

				excelobj.create_tcname(args)
				testcases_hash = excelobj.testcase_hash
				p "TestCase Size:"
				p testcases_hash.keys.size

				testcases_hash.each { |key, value|
					print key.encode("GBK"), "=>", value, "\n"
				}
				# print testcases_hash["点击向导进入到向导页面 ZLBF_3.1.4"]["steps"].encode("GBK")
				############################获取指定列的值###################
				# args     ={
				# 		:condition_col => "G",
				# 		:condition     => "三期".encode("GBK"),
				# 		:target_col    => "F",
				# 		:lines         => "100"
				# }
				# p excelobj.get_value_by_condition(args)
				#############################获取名字和ID，level
				# args ={
				# 		:condition_col => "G",
				# 		:condition     => "一期|二期|三期".encode("GBK"),
				# 		:name_col      => "C",
				# 		:level_col     => "F",
				# 		:id_col        => ["D", "E"],
				# 		:line          => "1",
				# 		:lines         => "800"
				# }
				# p excel_rs = excelobj.get_name_id_level(args)
				excelobj.close_excel()
		rescue => ex
				p ex.message.to_s
				puts ex.backtrace.join("\n")
				# excel.Quit
				excelobj.close_excel()
		end
end
  