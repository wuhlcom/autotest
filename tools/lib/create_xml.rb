#encoding: utf-8
require './template_creater'

module TestTool
    class CreateXml

        def initialize(excel_path)
            @excel = TestTool::Excel.new(excel_path)
        end

        # sheet_count 该excel有多少个页签
        def get_id_level(sheet_count=1, nameflag="C", idflag="D", levelflag="E")
            ex_hash = {}
            begin
                @excel.workbook
                for n in 1..sheet_count
                    @excel.worksheet_select(n) #定位到该sheet
                    line = 2
                    while @excel.range_select("#{nameflag}#{line}").value
                        id          = @excel.range_select("#{idflag}#{line}").value
                        level       = @excel.range_select("#{levelflag}#{line}").value
                        ex_hash[id] = level
                        line        =line+1
                    end #line的值为第一处空白行的行数
                end
            rescue => ex
                p ex.message
            ensure
                @excel.close_workbook #unless @excel.nil?
                @excel.close_excel #unless @excel.nil?
            end
            ex_hash
        end

        # ts_names = ["apmode", "attack", "backup", "internet", "reset", "system"]
        def create_frame(ts_names, ex_hash, passwd_xml="frame_all.xml", ts_path="../../frame")
            xml        = TestTool::Template.new()
            ts_names.each do |name|
                tcs_path = File.expand_path("../../../frame/#{name}", __FILE__)
                rs       = Dir.glob("#{tcs_path}/**/*.rb")

                #生成单个xml
                ts_name  = name
                tc_hash  = {}
                rs.each do |item|
                    tc_name          = item.slice(/.+\/(.+)\.rb/, 1)
                    tc_hash[tc_name] = {}
                end

                rs.each do |item|
                    tc_path   = item.slice(/(.+)\/.+\.rb/, 1)
                    tc_path   = tc_path.gsub(/.+\/autotest/, "../..")
                    tc_name   = item.slice(/.+\/(.+)\.rb/, 1)
                    tc_id     = tc_name.slice(/\s*(ZL.+)/i, 1)
                    tc_module = tc_name.slice(/ZL.+_\w_(.+)_/i, 1)

                    level = "X" #excel中未填写level时，在xml中暂将其赋为“X”
                    ex_hash.each do |key, value|
                        if key == tc_id
                            level = value
                            break
                        end
                    end
                    tc_hash[tc_name] = {"id" => tc_id, "level" => level, "path" => tc_path, "auto" => "y", "module" => tc_module}
                end
                xml.add_testcase_for_path(passwd_xml, ts_name, ts_path, tc_hash)
            end
        end

        def create_iam(ts_name, tc_names, ex_hash, passwd_xml="iam_all.xml", ts_path="../../iam_testcases")
            xml     = TestTool::Template.new()
            tc_hash = {}
            tc_names.each do |name|
                tcs_path = File.expand_path("../../../iam_testcases/#{name}", __FILE__)
                rs       = Dir.glob("#{tcs_path}/**/*.rb")

                rs.each do |item|
                    tc_name          = item.slice(/.+\/(.+)\.rb/, 1)
                    tc_hash[tc_name] = {}
                end

                rs.each do |item|
                    tc_path   = item.slice(/(.+)\/.+\.rb/, 1)
                    tc_path   = tc_path.gsub(/.+\/autotest/, "../..")
                    tc_name   = item.slice(/.+\/(.+)\.rb/, 1)
                    tc_id     = tc_name.slice(/\s*(IAM.+)/i, 1)
                    tc_module = tc_name.slice(/IAM_\w_(.+)_/i, 1)

                    level = "X" #excel中未填写level时，在xml中暂将其赋为“X”
                    ex_hash.each do |key, value|
                        if key == tc_id
                            level = value
                            break
                        end
                    end
                    tc_hash[tc_name] = {"id" => tc_id, "level" => level, "path" => tc_path, "auto" => "y", "module" => tc_module}
                end
            end
            xml.add_testcase_for_path(passwd_xml, ts_name, ts_path, tc_hash)
        end
    end
end

if $0==__FILE__
    excel_path = "E:/autotest/iam_testcases/IAM.xlsx"
    passwd_xml = "iam_all4.xml"
    # ts_path    = "../../iam_testcases"
    ts_name    = "manager"
    tc_names   = ["application", "devauth","device","manager","oauth","user"]
    cx         = TestTool::CreateXml.new(excel_path)
    ex_hash    = cx.get_id_level
    cx.create_iam(ts_name, tc_names, ex_hash, passwd_xml)
end