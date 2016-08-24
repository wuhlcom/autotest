require 'pp'
def gettc()
		files   = Dir.glob("E:/autotest/frame/**/*.rb")
		tc_namefile = File.new("d:/alltc.txt", "w")
		tcs_arr     =[]
		newtcs_arr  = []
		files.each { |tc_name|
				tcs_arr<< tc_name if (tc_name=~/\d\.rb/)
		}

		tcs_arr.each { |tc|
				# /.+\/(?<tc_name>.+).rb/=~tc
				tc_name = File.basename(tc,".rb")
				newtcs_arr<<tc_name
		}

		newtcs_arr.sort.each { |tc|
				tc_namefile.puts tc.encode("GBK")
		}
		tc_namefile.close
end


