require 'pp'
def gettc
		files   = Dir.glob("E:/autotest/frame/**/*.rb")
		tcnames = File.new("d:/alltc.txt", "w")
		tcs     =[]
		newtcs  = []
		files.each { |item|
				tcs<< item if (item=~/ZLBF|ZLRM|ZLBM/)
		}

		tcs.sort.each { |tc|
				/.+\/(?<tc_name>.+).rb/=~tc
				newtcs<<tc_name
		}

		newtcs.sort.each { |tc|
				tcnames.puts tc
		}
end


