require 'builder'
# builder = Builder::XmlMarkup.new
# xml = builder.person { |b| b.name("Jim"); b.phone("555-1234") }
# p xml #=> <person><name>Jim</name><phone>555-1234</phone></person>

# builder = Builder::XmlMarkup.new(:target => STDOUT, :indent => 2)
# builder.person { |b| b.name("Jim"); b.phone("555-1234") }
# Prints:
# <person>
#   <name>Jim</name>
#   <phone>555-1234</phone>
# </person>

# builder = Builder::XmlMarkup.new(:target => STDOUT, :indent => 2)
# builder.human{ builder.person { |b| b.name("Jim"); b.phone("555-1234") }
#  }
# <human>
# <person>
# <name>Jim</name>
#     <phone>555-1234</phone>
# </person>
# </human>

# xml_markup = Builder::XmlMarkup.new
# p xml_markup.div {xml_markup.strong("xxxx") }
#"<div><strong>text</strong></div>"

# xml = Builder::XmlMarkup.new
# xml.sample(:escaped=>"This&That", :unescaped=>:"Here&amp;There")
# p xml.target!  #=>    <sample escaped="This&amp;That" unescaped="Here&amp;There"/>
#
# xml_markup=Builder::XmlMarkup.new
# xml_markup.declare! :DOCTYPE, :chapter do |x|
#   x.declare! :ELEMENT, :chapter, :"(title,para+)"
#   x.declare! :ELEMENT, :title, :"(#PCDATA)"
#   x.declare! :ELEMENT, :para, :"(#PCDATA)"
# end
#
#
# xml_markup.comment! "This is a comment"
# #=>  <!-- This is a comment -->
# xml_markup.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
# #=>  <?xml version="1.0" encoding="UTF-8"?>

# builder = Builder::XmlMarkup.new(:target => STDOUT,:indent => 2)
# builder.human(:name => "human", :shit => "shit") {
#   builder.person(:arm => "arm") { |b| b.name("Jim"); b.phone("555-1234");b.name("Jim"); b.phone("555-1234")}
# }


dir     = File.dirname(__FILE__)
filepath="#{dir}/builder.xml"
builder = Builder::XmlMarkup.new(:indent => 2)
builder.instruct!
builder.human(:name => "human", :shit => "shit") {
  builder.person(:arm => "tow") { |b| b.name("Jim"); b.phone("555-1234") }
  File.open(filepath, "w+") { |file| file.puts builder.target! } #
  builder.person { |b| b.name("Tim"); b.phone("000-1233") }
  File.open(filepath, "w+") { |file| file.puts builder.target! }
  builder.person { |b| b.name("Aim"); b.phone("541-1236") }
  kakakka
  File.open(filepath, "w+") { |file| file.puts builder.target! }
}

File.open(filepath, "w+") { |file| file.puts builder.target! }
# File.open(filepath, "w") { |file| file.puts builder.target! }