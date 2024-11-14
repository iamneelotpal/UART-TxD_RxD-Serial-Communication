# UART-TxD_RxD-Serial-Communication

## Summary

***UART*** stands for ***Universal Asynchronous Receiver/Transmitter***. It’s not a communication protocol like SPI and I2C, but a physical circuit in a microcontroller, or a stand-alone IC. It is one of the most used device-to-device communication protocols. <br /> 

A UART’s main purpose is to transmit and receive serial data. In UART communication, two UARTs communicate directly with each other. 
The transmitting UART converts parallel data from a controlling device like a CPU into serial form, and transmits it in serial to the receiving UART, which then converts the serial data back into parallel data for the receiving device. Only ***two wires are needed*** to transmit data between two UARTs. Data flows from the transmitting UART's Tx pin to the receiving UART's Rx pin.<br />

In recent years, the popularity of UART has decreased: protocols like SPI and I2C have been replacing UART between chips and components. Instead of communicating over a serial port, most modern computers and peripherals now use technologies like Ethernet and USB. However, UART is still used for ***lower-speed and lower-throughput applications***, because it is very simple, low-cost and easy to implement.<br />

The UART interface ***does not use a clock signal to synchronize the transmitter and receiver devices***; it transmits data asynchronously. Instead of a clock signal, the transmitter generates a bitstream based on its clock signal while the receiver is using its internal clock signal to sample the incoming data. The point of synchronization is managed by having the same baud rate on both devices. Failure to do so may affect the timing of sending and receiving data that can cause discrepancies during data handling. The allowable difference of baud rate is up to 10% before the timing of bits gets too far off.<br />

## Data Transmission

In UART, the mode of transmission is in the form of a packet. The piece that connects the transmitter and receiver includes the creation of serial packets and controls those physical hardware lines. A packet consists of a start bit, data frame, a parity bit, and stop bits.<br />

![Data Teransmission UART](https://github.com/user-attachments/assets/2bc83990-ebe4-4721-9356-3bca0230d654)


### Start Bit
The UART data transmission line is normally held at a high voltage level when it’s not transmitting data. To start the transfer of data, the transmitting UART pulls the transmission line from high to low for one (1) clock cycle. When the receiving UART detects the high to low voltage transition, it begins reading the bits in the data frame at the frequency of the baud rate.<br />

![335962-fig-04](https://github.com/user-attachments/assets/02e363d5-2bc7-4e7e-b763-4821fb59dea3)

### Data Frame
The data frame contains the actual data being transferred. It can be five (5) bits up to eight (8) bits long if a parity bit is used. If no parity bit is used, the data frame can be nine (9) bits long. In most cases, the data is sent with the least significant bit first.<br />

![335962-fig-05](https://github.com/user-attachments/assets/afeaaf55-4b57-4ef7-87f5-ca974dbf7f83)

### Parity
Parity describes the evenness or oddness of a number. The parity bit is a way for the receiving UART to tell if any data has changed during transmission. Bits can be changed by electromagnetic radiation, mismatched baud rates, or long-distance data transfers.<br />

![335962-fig-06](https://github.com/user-attachments/assets/2f5155e5-8121-4274-9072-6f300de2e6e1)

After the receiving UART reads the data frame, it counts the number of bits with a value of 1 and checks if the total is an even or odd number. If the parity bit is a 0 (even parity), the 1 or logic-high bit in the data frame should total to an even number. If the parity bit is a 1 (odd parity), the 1 bit or logic highs in the data frame should total to an odd number.<br />

When the parity bit matches the data, the UART knows that the transmission was free of errors. But if the parity bit is a 0, and the total is odd, or the parity bit is a 1, and the total is even, the UART knows that bits in the data frame have changed.<br />

### Stop Bits
To signal the end of the data packet, the sending UART drives the data transmission line from a low voltage to a high voltage for one (1) to two (2) bit(s) duration.<br />

![335962-fig-07](https://github.com/user-attachments/assets/6292b954-227c-4a5f-8c98-cf9029cf8efd)

## Steps 

### First: 
The transmitting UART receives data in parallel from the data bus.
### Second: 
The transmitting UART adds the start bit, parity bit, and the stop bit(s) to the data frame.
### Third:
The entire packet is sent serially starting from start bit to stop bit from the transmitting UART to the receiving UART. The receiving UART samples the data line at the preconfigured baud rate.
### Fourth: 
The receiving UART discards the start bit, parity bit, and stop bit from the data frame.
### Fifth:
The receiving UART converts the serial data back into parallel and transfers it to the data bus on the receiving end.

## Architecture

### UART Transmission Module
![UART_Tx](https://github.com/user-attachments/assets/7a7a7eb8-c5ef-4ffc-9651-01c2040efc42)

#### Baud Rate Generator Unit

***Baud Rate*** is the rate at which the number of signal elements or changes to the signal occurs per second when it passes through a transmission medium. The higher the baud rate, the faster the data is sent/received.
This unit supports four possible baud rates:

*   Baud rate of 2400 bps
*   Baud rate of 4800 bps
*   Baud rate of 9600 bps
*   Baud rate of 19200 bps
  
**Notes:**
*   The latter two are the most common.
*   The values of the timer calculated for the baud rates are for the **50MHz** system's clock, those values need to be re-calculated for different clock frequencies.

  #### Parity Bit Unit

***Parity bit*** is a method of checking if the data packet is sent correctly by calculating the number of 1's in the packet and providing the parity bit according to the ***parity type***, then checking if the Received data packet has the same parity bit.

This unit supports three parity types:
*   No Parity
*   Odd Parity
*   even Parity
  
**Notes:**
*   This method can discover a one-bit error, if two bits are flipped concurrently the packet will be considered the correct packet.
*   The default case is that there is no parity bit.

  #### PISO Unit

***Parallel-Input-Serial-Output*** shift register, this unit is responsible for converting the data from a parallel bus to serial data in a single wire, it is controlled by an ***FSM logic*** to do so, It takes about 11 baud_clk cycles to send the whole data packet.
It is the heart of the transmission unit.

##### Tx FSM
![Tx_FSM](https://github.com/user-attachments/assets/da9abe5a-1f78-4a7f-986c-4f45f33453c5)
**Notes:**
*   The **Done Flag** indicates whether the transmission is done or not, to enable another packet to get ready to be sent.
*   The **Active Flag** indicates whether the transmitter is in progress or an **idle state**.


### UART Receiver Module
![UART_Rx](https://github.com/user-attachments/assets/059de3c0-cda3-4cb4-92f7-975c4f02bb05)

#### Oversampling Unit
It is a ***Baud Rate Generator***, but uses a sampling rate of 16 times the baud rate, which means that each serial bit is sampled 16 times, this methodology shifts the time to read the data to the center of the bit.

#### SIPO Unit

***Serial-Input-Parallel-Output*** shift register, this unit is responsible for converting the data from serial data to the parallel bus, it is controlled by an ***FSM logic*** to do so, It takes about 11 baud_clk cycles to Receive the whole data packet.
It is the heart of the Receiver unit.

##### Rx FSM
![Rx_FSM](https://github.com/user-attachments/assets/27185ab7-6064-4fc1-95d5-b3967aa3b2c0)

#### DeFrame Unit
De-Frame unit is responsible for separating the frame into four main parts: **Strat bit**, **Data packet**, **Parity bit**, **Stop bit**, it is the final stage, regardless of the in the Receiver.

#### Error Check Unit

This unit is indispensable, noise is everywhere and it is most likely that at some time the data will get affected by it, thus we always need some sort of confirmation that the data is sent correctly, if not it will be re-sent. This unit supports three error flags:

1.  **Parity Error**: re-checks the data sent by the Tx unit, produces a parity bit, then compares it with the one from the *DeFrame* unit, it rises to logic 1 if they are not equal.
2.  **Start Error**: re-checks the start bit, whether it equals logic 0 or not, it rises to logic 1 if they are not equal.
3.  **Stop Error**: re-checks the start bit, whether it equals logic 1 or not, it rises to logic 1 if they are not equal.

