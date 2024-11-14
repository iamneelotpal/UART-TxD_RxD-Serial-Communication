# UART-TxD_RxD-Serial-Communication

## Summary

***UART*** stands for ***Universal Asynchronous Receiver/Transmitter***. It’s not a communication protocol like SPI and I2C, but a physical circuit in a microcontroller, or a stand-alone IC. It is one of the most used device-to-device communication protocols. <br /> 

A UART’s main purpose is to transmit and receive serial data. In UART communication, two UARTs communicate directly with each other. 
The transmitting UART converts parallel data from a controlling device like a CPU into serial form, and transmits it in serial to the receiving UART, which then converts the serial data back into parallel data for the receiving device. Only ***two wires are needed*** to transmit data between two UARTs. Data flows from the transmitting UART's Tx pin to the receiving UART's Rx pin.<br />

In recent years, the popularity of UART has decreased: protocols like SPI and I2C have been replacing UART between chips and components. Instead of communicating over a serial port, most modern computers and peripherals now use technologies like Ethernet and USB. However, UART is still used for ***lower-speed and lower-throughput applications***, because it is very simple, low-cost and easy to implement.<br />

The UART interface ***does not use a clock signal to synchronize the transmitter and receiver devices***; it transmits data asynchronously. Instead of a clock signal, the transmitter generates a bitstream based on its clock signal while the receiver is using its internal clock signal to sample the incoming data. The point of synchronization is managed by having the same baud rate on both devices. Failure to do so may affect the timing of sending and receiving data that can cause discrepancies during data handling. The allowable difference of baud rate is up to 10% before the timing of bits gets too far off.<br />

## Data Transmission

In UART, the mode of transmission is in the form of a packet. The piece that connects the transmitter and receiver includes the creation of serial packets and controls those physical hardware lines. A packet consists of a start bit, data frame, a parity bit, and stop bits.<br />

![Data Transmission Frame](https://github.com/iamneelotpal/UART-TxD_RxD-Serial-Communication/blob/main/Images/Data%20Teransmission%20UART%20.svg.)

### Start Bit
The UART data transmission line is normally held at a high voltage level when it’s not transmitting data. To start the transfer of data, the transmitting UART pulls the transmission line from high to low for one (1) clock cycle. When the receiving UART detects the high to low voltage transition, it begins reading the bits in the data frame at the frequency of the baud rate.<br />

### Data Frame
The data frame contains the actual data being transferred. It can be five (5) bits up to eight (8) bits long if a parity bit is used. If no parity bit is used, the data frame can be nine (9) bits long. In most cases, the data is sent with the least significant bit first.<br />

### Parity
Parity describes the evenness or oddness of a number. The parity bit is a way for the receiving UART to tell if any data has changed during transmission. Bits can be changed by electromagnetic radiation, mismatched baud rates, or long-distance data transfers.<br />

After the receiving UART reads the data frame, it counts the number of bits with a value of 1 and checks if the total is an even or odd number. If the parity bit is a 0 (even parity), the 1 or logic-high bit in the data frame should total to an even number. If the parity bit is a 1 (odd parity), the 1 bit or logic highs in the data frame should total to an odd number.<br />

When the parity bit matches the data, the UART knows that the transmission was free of errors. But if the parity bit is a 0, and the total is odd, or the parity bit is a 1, and the total is even, the UART knows that bits in the data frame have changed.<br />

### Stop Bits
To signal the end of the data packet, the sending UART drives the data transmission line from a low voltage to a high voltage for one (1) to two (2) bit(s) duration.<br />





