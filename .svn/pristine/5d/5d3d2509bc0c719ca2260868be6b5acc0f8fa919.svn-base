#encoding:utf-8
#分类： ruby/rails2013-05-31 18:42 1701人阅读 评论(0) 收藏 举报
#测试工作中，批量的数据通常会放到excel表格中,测试输出的数据写回表格中,这样输入输出易于管理,同时清晰明了
#使用ruby来操作excel文件首先需要在脚本里包含以下语句
require 'win32ole'
#把win32ole包含进来后,就可以通过和windows下的excelapi进行交互来对excel文件进行读写了.

# 打开excel文件,对其中的sheet进行访问:
excel     =WIN32OLE::new('excel.Application')
workbook  =excel.Workbooks.Open('c:\examples\spreadsheet.xls')
worksheet =workbook.Worksheets(1) #定位到第一个sheet
worksheet.Select
puts worksheet.visible #判断sheet是否存在
# 读取数据:
worksheet.Range('a12')['Value'] #读取a12中的数据
data =worksheet.Range('a1:c12')['Value'] #将数据读入到一个二维表

# 找到第一处a列的值为空值
line = 1
while worksheet.Range("a#{line}")['Value']
	line=line+1
end #line的值为第一处空白行的行数

# 将第一列的值读入到一个数组中
line = '1'
data = []
while worksheet.Range("a#{line}")['Value']
	data << worksheet.Range("a#{line}:qos#{line}")['Value']
	line.succ!
end

#将数据写入到excel表格中
worksheet.Range('e2')['Value']    = Time.now.strftime '%qos/%m/%Y' #单个值
worksheet.Range('a5:c5')['Value'] = ['Test', '25', 'result'] #将一个数组写入

# 调用宏定义
excel.Run('SortByNumber')
# 设置背景色
worksheet.Range('a3:f5').Interior['ColorIndex']= 36 #pale yellow
# 将背景色恢复成无色
worksheet.Range('a3:f5').Interior['ColorIndex']= -4142 # XlColorIndexNone constant
# 使用Excelconstant 将背景色恢复成无色
worksheet.Range('a3:f5').Interior['ColorIndex']= ExcelConst::XlColorIndexNone

# 保存
workbook.save #保存
workbook.Close #关闭
workbook.SaveAs 'myfile.xls'
#默认路径是系统定义的"我的文档"

# 结束会话
excel.Quit
# 一些相对完整的代码片段
# 创建一个excel文件并保存
require 'win32ole'
excel         =WIN32OLE.new("excel.application")
excel.visible = true # in case you want to see what happens
workbook      =excel.workbooks.add
workbook.saveas('c:\examples\spreadsheet1.xls')
workbook.close
# 操作excel文件的几个重要元素
# Excel =>workbook => worksheet => range(cell)
# 我理解的是excel为类名,workbook为一个具体的(excel文件)实例,创建好实例后,worksheet是实例(workbook,工作簿)中的一个工作表,然后可
# 以对工作表中的每个单元格(range(cell))进行具体的读写------------------按照这样操作肯定没有错,不过下面的这些语句又让我有些疑惑

excel.workbooks("Mappe1").worksheets("Tabelle1").range("a1").value #读取名为Mappe1的excel文件中工作表名为Tabelle1的a1单元格中的值
excel.worksheets("Tabelle1").range("a1").value #作用同第一条语句
excel.activeworkbook.activesheet.range("a1").value #作用同第一条语句
excel.activesheet.range("a1").value #作用同第一条语句
excel.range("a1").value #作用同第一条语句
# excel可以直接操作所有的属性,默认为当前活跃的工作簿/工作表

# 对单元格的操作:
# 某个单元格:
excel     =WIN32OLE::new('excel.Application')
workbook  =excel.Workbooks.Open('c:\examples\spreadsheet.xls')
worksheet =workbook.Worksheets(1) #定位到第一个sheet
sheet     =worksheet.Select
sheet.range("a1")
# a1到c3的值:
sheet.range("a1", "c3")
#或
sheet.range("a1:c3")
# 第一列:
sheet.range("a:a")
# 第三行:
sheet.range("3:3")
# 获得单元格的值:
# range.text #读取值,返回为字符串格式,如果单元格内为数字,有可能会被截断小数点后的位数
sheet.range("a1").text
# range.value #读取值,数字不会截断
sheet.range("a1").value
# 对单元格设置值
sheet.range("a1").value= 1.2345
# 或
sheet.range("a1").value= '1.2345'
# 迭代访问:
sheet.range("a1:a10").each { |cell| putscell.value }
# 如果范围是一个矩形,则会按行循环迭代访问
sheet.range("a1:b5").each { |cell| putscell.value }
# block迭代,并打印出每行的第一个值
sheet.range("b3:c7").rows.each { |r| putsr.cells(1, 1).value }

