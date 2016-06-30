#encoding:utf-8
#将excel文件转换成xml文件
require 'win32ole'
require './create_excel'
# require './parser_frame.xml'
module TestTool
    class ExcelToXml

        #将用例存入excel中
        def write_excel(excel_file_dir, excel_name, excel_sheet)
            excel_path = excel_file_dir+"/#{excel_name}" #excel存放路径
            creater    = TestTool::CreateExcel.new(excel_path, excel_sheet, false)
            begin
                args = {
                    :index   => 1,
                    :xml_dir => excel_sheet,
                }
                creater.xml_to_excel(args)
                creater.saveas_workbook(excel_name, excel_file_dir)
            rescue => ex
                p ex
                print ex.backtrace.join("\n")
            ensure
                creater.close_workbook unless creater.nil?
                creater.close_excel unless creater.nil?
            end
        end

        #得到需执行的脚本用例，即excel中是否执行字段为"Y"的用例
        def get_execute_tcs(excel_file_dir, excel_name, excel_sheet)
            execute_arr = []
            excel_path  = excel_file_dir+"/#{excel_name}" #excel存放路径
            creater     = TestTool::CreateExcel.new(excel_path, excel_sheet, false)
            begin
                args        = {
                    :index   => 1,
                    :xml_dir => excel_sheet,
                }
                # 得到要执行的用例数组
                execute_arr = creater.get_tcname(args)
            rescue => ex
                p ex
                print ex.backtrace.join("\n")
            ensure
                creater.close_workbook unless creater.nil?
                creater.close_excel unless creater.nil?
            end
            execute_arr
        end

        #将excel转换成xml
        #excel表中是否执行的值为“Y”的，就将frame_all.xml中auto的值改为"y"
        def excel_switch_xml(tc_names)
            xml = "e:/autotest/frame/frame_all.xml"
            obj = TestTool::XML.new(xml)
            obj.change_all_tc_auto("n", xml) #先将xml中所有auto的属性值置为"n"
            tc_names.each do |key, value|
                obj.change_tc_auto_byname(key, value, "y", xml)
            end
        end

        #获取所有NG的日志
        def ng_excel(log_dir)
            current        = File.expand_path("./reports/#{log_dir}")
            xml_path_arr   = Dir.glob("#{current}/*.xml")
            failures_log   = TestTool::XML.get_failure(xml_path_arr)
        end
    end
end

if __FILE__ ==$0
    xml_obj  = TestTool::ExcelToXml.new

    excel_sheet    = "用例" #excel的sheet名
    excel_file     = "excel_switch_xml"
    excel_name     = "#{excel_file}.xlsx" #excel文件名
    excel_file_dir = File.dirname(File.expand_path(__FILE__))
    # xml_obj.write_excel(excel_file_dir, excel_name, excel_sheet)
    tc_names = xml_obj.get_execute_tcs(excel_file_dir, excel_name, excel_sheet)
    xml_obj.excel_switch_xml(tc_names)
end