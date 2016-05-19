#import：函数传入参数的参数类型，其中 "p" 对应指针，"n","l"对应long，"i"对应int，"v" 对应void，如果有多个参数，
# 可以通过 ["p","n"]数组的方式来实现，其中置为nil可以表示没有参数
# Win32Api.new(dllname, proc, import, export)
# TYPEMAP = {"0" => DL::TYPE_VOID, "S" => DL::TYPE_VOIDP, "I" => DL::TYPE_LONG}
require "Win32API"
require 'dl'
# BOOL WINAPI GetComputerName(
#            _Out_   LPTSTR  lpBuffer,
#           _Inout_ LPDWORD lpnSize
#            );

def get_computer_name
  name = "  "*128
  size = "128"
  Win32API.new('kernel32', 'GetComputerName', ['P', 'P'], 'I').call(name, size)
  name.unpack("A*")
end

p "get_computer_name"
p get_computer_name

# BOOL WINAPI GetComputerName(
#            _Out_   LPTSTR  lpBuffer,
#           _Inout_ LPDWORD lpnSize
#            );
# Win32API.new('kernel32', 'GetComputerName', ['P', 'P'], 'I').call(name, size)
kernel32 = DL.dlopen('kernel32')
computername = DL::CFunc.new(kernel32['GetComputerName'], DL::TYPE_LONG, 'Computername')
name = " "*128
size = "128"
# [name,size].pack("pp").unpack"l!*"
computername.call([name, size].pack("pp").unpack "l!*")
# p name.unpack("A*")

# require "Win32API"
# qq=Win32API.new('ipsearcher','_GetAddress',['P'],'P')
# str=qq.call('192.168.10.75')
# puts str

dllname = "wlanapi.dll"
# DWORD WINAPI WlanOpenHandle(
#                  _In_ DWORD dwClientVersion,
#                  _Reserved_ PVOID pReserved,
#                  _Out_ PDWORD pdwNegotiatedVersion,
#                 _Out_ PHANDLE phClientHandle
#              );
def get_wlanOpenHandle(dllname)
  c_version = 2
  c_resrver = ""
  c_out1 = 0
  c_out2 = ""
  pro=Win32API.new(dllname, "WlanOpenHandle", ['L', 'p', 'l', 'p'], "v")
  pro.call(c_version, c_resrver, c_out1, c_out2)
end

# p "get_wlanOpenHandle"
# p get_wlanOpenHandle(dllname)

api = Win32API.new('wlanapi', 'WlanOpenHandle', ['L', 'L', 'P', 'P'], 'I')
negver = [0].pack('L')
# handle = [0].pack('l') # this assumes 4 byte pointer
ret = api.call(2, 0, negver, handle)
puts "WlanOpenHandled returned #{ret}"
puts "Negotiated version: #{negver.unpack('L')}, Handle is #{handle.unpack('L*')}"

p "get_wlanei"
# DWORD WINAPI WlanEnumInterfaces(
#                  _In_       HANDLE                    hClientHandle,
#                  _Reserved_ PVOID                     pReserved,
#                 _Out_      PWLAN_INTERFACE_INFO_LIST *ppInterfaceList
#              );

# def get_wlanei(dllname)
c_handle = 1
c_reserved = 0
c_interfacelist=" "*10000
dllname = "wlanapi.dll"
pro=Win32API.new(dllname, "WlanEnumInterfaces", ['p', 'l', 'p'], "v")
p pro.call(handle, c_reserved, c_interfacelist)
p c_interfacelist.unpack("l*")
# p c_interfacelist
#   c_interfacelist
# end
#  p get_wlanei(dllname)


# DWORD WINAPI WlanGetProfile(
#        _In_              HANDLE  hClientHandle,
#        _In_        const GUID    *pInterfaceGuid,
#        _In_              LPCWSTR strProfileName,
#        _Reserved_        PVOID   pReserved,
#        _Out_             LPWSTR  *pstrProfileXml,
#        _Inout_opt_       DWORD   *pdwFlags,
#        _Out_opt_         PDWORD  pdwGrantedAccess
#              );

def get_profile(dllname)
  c_handle = 87
  c_guid = "a9e73df9-2768-459d-98f9-38146d60734b".to_i
  c_profilename = "wuhongliang".to_i
  c_reserverd = 10
  c_strxml = 1000
  c_flag = 10
  c_access = 10
  pro=Win32API.new(dllname, "WLanGetProfile", ['i', 's', "o", "s", "s", "s", "s"], "v").call(c_handle, c_guid, c_profilename, c_reserverd, c_strxml, c_flag, c_access)
  # pro.call(c_handle,c_guid,c_profilename,c_reserverd,c_strxml,c_flag,c_access)
end

# p get_profile(dllname)


# DWORD WINAPI WlanScan(
#            _In_             HANDLE         hClientHandle,
#            _In_       const GUID           *pInterfaceGuid,
#            _In_opt_   const PDOT11_SSID    pDot11Ssid,
#            _In_opt_   const PWLAN_RAW_DATA pIeData,
#            _Reserved_       PVOID          pReserved
#              );

def get_wlanScan(dllname)
  c_handle = 1
  c_guid = "a9e73df9-2768-459d-98f9-38146d60734b"
  c_ssid = nil
  c_data = nil
  c_reserverd = nil
  pro=Win32API.new(dllname, "WlanScan", ['I', 'O', 'O', 'O', '0'], "I")
  pro.call(c_handle, c_guid, c_ssid, c_data, c_reserverd)
end

# p get_wlanScan dllname

# module Test
#   dllname = File.join(File.dirname(File.expand_path(__FILE__)), "/wlan.dll")
#   extend DL::Importer
#   dlload dllname
#   extern "void WlanConnect(int,int,int,int)"
# end
# Test.WlanOpenHandle 3,4,4,5

# DWORD WINAPI WlanDisconnect(
#              _In_             HANDLE hClientHandle,
#              _In_       const GUID   *pInterfaceGuid,
#             _Reserved_       PVOID  pReserved
#              );

# DWORD WINAPI WlanConnect(
#                  _In_             HANDLE                      hClientHandle,
#                   _In_       const GUID                        *pInterfaceGuid,
#                  _In_       const PWLAN_CONNECTION_PARAMETERS pConnectionParameters,
#              _Reserved_       PVOID                       pReserved
#              );
def get_wlanConnect(dllname)
  c_handle = 1
  c_guid = "a9e73df9-2768-459d-98f9-38146d60734b"
  c_parameters = ""
  c_reserverd = nil
  pro=Win32API.new(dllname, "WlanConnect", ['I', 'p', 'p', 'p'], "I")
  pro.call(c_handle, c_guid, c_parameters, c_reserverd)
end

# p "get_wlanConnect"
# p get_wlanConnect(dllname)

# require 'dl'
# require 'dl/import'

# module LibSum
#   extend DL::Importer
#   dlload 'wlanapi'
#   extern 'void WlanConnect(double,char,char)'
# end
# p "LibSum"
# p LibSum.WlanConnect 1,12,1

# You can call GetPixel like this:
require 'dl/func'
$gdi32 = DL.dlopen('gdi32')

def GetPixel hwnd, x, y
  getpixel = DL::Function.new(DL::CFunc.new($gdi32['GetPixel'],
                                            DL::TYPE_LONG, 'GetPixcel'), [DL::TYPE_LONG, DL::TYPE_INT, DL::TYPE_INT])
  getpixel.call(hwnd, x, y)
end

GetPixel 0, 1, 1

# https://msdn.microsoft.com/en-us/library/windows/desktop/ms645505(v=vs.85).aspx
# int WINAPI MessageBox(
#              _In_opt_ HWND    hWnd,
#             _In_opt_ LPCTSTR lpText,
#             _In_opt_ LPCTSTR lpCaption,
#             _In_     UINT    uType
#            );
user32 = DL.dlopen('user32')
msgbox = DL::CFunc.new(user32['MessageBoxA'], DL::TYPE_LONG, 'MessageBox')
# msgbox.call([0, "Hello", "Message Box", 0].pack('L!ppL!').unpack('L!*'))




