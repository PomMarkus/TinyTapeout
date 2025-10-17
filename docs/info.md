<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works
Hardware Adress: 1000111(1/0) -> 0x8E (0x8F for write - but is not implemented)

DATA1 (0x08):
DATA2 (0x09):
DATA3 (0x0A):
DATA4 (0x0B):
DATA5 (0x0C):
DATA6 (0x0D):
DATA7 (0x0E):
DATA8 (0x0F):


CTRL0 (0x00): 
0        1         2        3        4        5        6        7
E_DO     E_ST      -        -        CB0      CB1      CB2      CB3

CTRL1 (0x01):
0        1         2        3        4        5        6        7
CB4      CB5       CB6      CB7      CB8      CB9      CB10     CB11

CTRL2 (0x02):
0        1         2        3        4        5        6        7
CB12     CB13      CB14     CB15     CB16     CB17     CB18     CB19

E_DA: Enable Direct Output
When this bit is set, the Stepper is turned off and the direct output is enabled.
Direct output means, that the input pins will be enabled on the output for the 7-seg. Display.

E_ST: Enable Stepper
When this Bit is set HIGH and E_DA is LOW, then the Stepper is enabled. The stepper steps through the DATAx register.
It Starts wit OFF, DATA1, then DATA2, ... , DATA8, off, DATA1, ... . The stepping speed can be ajusted with the Bits CB0 to CB19.

CB0-CB19: Compare Bit 0-19
A 20-Bit counter is implemented. With this bits a comparevalue can be set.
The inital clock operates with 100kHz. 


## How to test
use an i2c Master and write values to the 13 Registers.

## External hardware
7-segment display connected to all 8 output pins
8 input switches
i2c connection - SDA on bus_io0 and SCL on bus_io1

