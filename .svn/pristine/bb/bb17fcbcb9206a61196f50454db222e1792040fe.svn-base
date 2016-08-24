=begin
	Filename : GetDiff
	Author : wuhongliang
	Date : 2015-08-08
 Disciption:Compare two file
=end
class FileCompare
	# run
	# 	cmp2file
	#
	# 	若是存在不同的行 ， 则输出 ：
	# 	----num : 3-----
	# 	file1 : localname=nick
	# 	file2 : localname=bob
	#
	# 	若是有两个文件中行数不等 ， 还会输出 ：
	# 	Exception : Maybe file2 was not enough lines.Cant find the data when check line ..
	#   若是两个文件完全相同 ， 则无任何输出
	def cmp2file(f1path,f2path)
		# f1           =File.open($*[0], "r")
		# f2           =File.open($*[1], "r")
		f1 =File.open(f1path, "r")
		f2 =File.open(f2path, "r")
		num          =0

		#Get data from file as array
		num1, f1array=getFileLine(f1)
		num2, f2array=getFileLine(f2)

		#ensure the numberof loop
		if num1>num2
			num=num1
		else
			num=num2
		end

		flag=true
		#Loop: compare two linesfrom difference file
		for i in (0..num-1)
			mesg1='Exception:Maybe file'
			mesg2=' was not enough lines. Cant find the data when check line '
			if f1array[i] != nil and f2array[i] != nil
				if f1array[i] != f2array[i]
					puts "----num: #{i}-----"
					puts "#{f1path}: "+f1array[i].to_s
					puts "#{f2path}: "+f2array[i].to_s
					puts "\n"
					flag=false
				end
			else
				if f1array[i] != nil
					puts mesg1+f1path+ mesg2+(i+1).to_s
					flag=false
					break
				else
					if f2array[i] != nil
						puts mesg1+f2path+ mesg2+(i+1).to_s
						flag=false
						break
					else
						flag=false
						puts 'exception on "if f1array[i] != nil and f2array[i] != nil"'
						break
					end
				end
			end
		end
		f1.close
		f2.close
		return flag
	end

	def getFileLine(f)
		farray=[]
		num   =0
		f.each do |fi|
			num   +=1
			farray+=[fi.strip]
		end
		return num, farray
	end


	def print_file(filepath)
		filepath = "E:/Automation/ruby_test/filecompare/rt2880_settings.dat"
		File.open(filepath, "r") do |file|
			while line=file.gets
				puts file.lineno
				puts line
			end
		end
	end

	def print_file_line(filepath)
		filepath = "E:/Automation/ruby_test/filecompare/rt2880_settings.dat"
		file     = File.open(filepath, "r")
		file.each_line do |line|
			puts line.encode("GBK")
		end
	end

end

if __FILE__==$0
	filepath = "E:/Automation/ruby_test/filecompare/rt2880_settings.dat"
	filepath2 = "E:/Automation/ruby_test/filecompare/file2.txt"
	FileCompare.new.cmp2file(filepath,filepath2)
end