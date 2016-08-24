# require 'zip'
# require 'Rake::PackageTask'
#  path = "D:/webdownloads/config.tgz"
# # RAR::ZipFile::open(path) do |zfile|
# # 		zfile.each do |zent|
# # 				puts zent
# # 				puts zent.is_directory # 判断是不是目录 是目录你就创建一个就行了!
# # 		end
# # end
# require 'rake'
# a = Rake::PackageTask.new("aa")
# p a.tgz_file
require "tardotgz"
class FruitRollup
 include Tardotgz
end
fr = FruitRollup.new
archive_path = "D:/webdownloads/config(1).tgz"
# print fr.read_from_archive(archive_path, /wireless/)
print fr.read_from_archive(archive_path, /network/)
