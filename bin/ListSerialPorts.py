#!/usr/bin/env python3 
import serial.tools.list_ports

ports = list(serial.tools.list_ports.comports())
for p in ports:
	print(p[0],p[2])
