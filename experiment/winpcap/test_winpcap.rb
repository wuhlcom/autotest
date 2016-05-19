require 'ffi/pcap'
######################
p dev     = FFI::PCap.device_names.first
# netp    = FFI::MemoryPointer.new(find_type(:bpf_uint32))
# maskp   = FFI::MemoryPointer.new(find_type(:bpf_uint32))
# errbuf  = FFI::PCap::ErrorBuffer.new
#
# FFI::PCap.pcap_lookupnet dev, netp, maskp, errbuf
#
# puts netp.get_array_of_uchar(0,4).join('.')
# puts maskp.get_array_of_uchar(0,4).join('.')
########################################
#pcap_findalldevs
devices = FFI::MemoryPointer.new(:pointer)
errbuf  = FFI::PCap::ErrorBuffer.new

p FFI::PCap.pcap_findalldevs(devices, errbuf)
node = devices.get_pointer(0)
dev = FFI::PCap::Interface.new(node) # return a structure object for exploring :
p dev.name
p dev.description
p dev.addresses
p dev.addresses.addr
p FFI::PCap.pcap_freealldevs(node)
###############################################
#We¡¯ve got our active device, so let listen to packets
dev = FFI::PCap.device_names[1]  # or another for you

pcap = FFI::PCap::Live.new(:dev => dev)   # for this time, listening is active, as show with stats

pcap.stats
pcap.stats.ps_recv

pcap.datalink.describe

pakt = []

pcap.loop(:count => 1) do |this,pkt|   # :count => -1 for infinite loop, break with .breakloop method
  pakt << pkt
  puts "#{pkt.time} :: #{pkt.len}"
  pkt.body.each_byte {|x| print "%0.2x " % x }
  putc "\n"
end
