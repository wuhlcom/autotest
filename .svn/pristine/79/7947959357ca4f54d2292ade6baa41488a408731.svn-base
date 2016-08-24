require 'ffi'
module Wpcap
  extend FFI::Library
  ffi_lib('wpcap')
  ffi_convention(:stdcall)
  attach_function(:findnics, :pcap_findalldevs_ex, [:pointer, :pointer, :pointer, :pointer], :int)
end
devices = FFI::MemoryPointer.new(:pointer)
errbuf  = FFI::Buffer.new(256)
p Wpcap.findnics(devices, devices, devices, errbuf)


