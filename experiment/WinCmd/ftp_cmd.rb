# p "111"
# p `ftp`
# p "2222"
# p `open 10.10.10.1`
# p "3333"
# p `admin\n`
# p` \n`
# %x("ftp")
# IO.pipe("ftp")
# open("|ftp","r") { |f|
# 	p "111"
# 	f.puts "open 10.10.10.1"
# 	p "222"
# 	f.puts "admin"
# 	p "3333"
# 	f.puts ""
# }
# system("ftp")
p `ftp\nopen 10.10.10.1 admin\n ""\n`