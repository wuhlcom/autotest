@echo off
rem �����з����������
echo start Druby server...
start %cd%\Druby_server.bat
echo start HTTP server
start %cd%\HTTPServerWAN.bat
echo start UDP server
start %cd%\UDPServerWAN.bat
echo start TCP server
start %cd%\TCPServerWAN.bat
echo "���з����ѿ���"
