# Senseback_controller

Code for the bluetooth controller. This system maintains a bluetooth link to the target device (implant) and takes data in over UART and determines whether the data: 
1) contains a command for the controller or 
2) is to be transmitted to the target device (implant).


SETUP

Default Equipment required is 1 NRF52 development board
1 USB - UART cable
+ the device you are trying to talk to (e.g. Senseback implant)

Connect gnd, RX and TX of the UART cable to the NRF52 dev board (RX of the cable is connected to TX of the board and vice-versa). 
Start a serial terminal (we've been using realterm which needs to be downloaded and we have a matlab script for setting it up. There are also some scripts for sending data from matlab.)

