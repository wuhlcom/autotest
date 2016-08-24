# Examples
# Reading ICMP packets from a live interface.
require 'ffi/pcap'
p pcap = FFI::PCap::Live.new(:dev     => '\\Device\\NPF_{C3FC08EA-71A1-4DE5-957F-4B9648D96562}',
                           :timeout => 1,
                           :promisc => true,
                           :handler => FFI::PCap::Handler)

pcap.setfilter("arp")
pcap.loop() do |this, pkt|
  puts "#{pkt.time}:"
  pkt.body.each_byte { |x| print "%0.2x " % x }
  putc "\n"
end
# Reading packets from a pcap dump file:

# pcap = FFI::PCap::Offline.new("d:/foo.cap")

# pcap.loop() do |this, pkt|
#   puts "#{pkt.time}:"
#
#   pkt.body.each_byte { |x| print "%0.2x " % x }
#   putc "\n"
# end

# Replaying packets from a pcap dump file on a live interface:

p live = FFI::PCap::Live.new(:device => '\\Device\\NPF_{C3FC08EA-71A1-4DE5-957F-4B9648D96562}')
# offline = FFI::PCap::Offline.new("./foo.cap")
#
# if live.datalink == offline.datalink
#   offline.loop() { |this, pkt| live.inject(pkt) }
# end