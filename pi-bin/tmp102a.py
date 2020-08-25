#!/usr/bin/python
import smbus
#0 = /dev/i2c-0
#1 = /dev/i2c-1
I2C_BUS = 1
bus = smbus.SMBus(I2C_BUS)
    
#7 bit address (will be left shifted to add the read write bit)
DEVICE_ADDRESS = 0x48      

#Read the temp register
temp_reg_12bit = bus.read_word_data(DEVICE_ADDRESS , 0 )
temp_low = (temp_reg_12bit & 0xff00) >> 8
temp_high = (temp_reg_12bit & 0x00ff)
#convert to temp from page 6 of datasheet
temp  = ((( temp_high * 256 ) + temp_low) >> 4 )
#handle negative temps
if temp > 0x7FF:
	temp = temp-4096;
temp_C = float(temp) * 0.0625
temp_F = temp_C * 9/5+32
print "Temp = %4.1f C -- %4.1f F" % (temp_C,temp_F)
