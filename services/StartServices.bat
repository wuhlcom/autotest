@echo off
rem 将所有服务调用起来
echo start Druby server...
start %cd%\Druby_server.bat
echo start HTTP server
start %cd%\HTTPServerWAN.bat
echo start UDP server
start %cd%\UDPServerWAN.bat
echo start TCP server
start %cd%\TCPServerWAN.bat
echo "所有服务已开启"
