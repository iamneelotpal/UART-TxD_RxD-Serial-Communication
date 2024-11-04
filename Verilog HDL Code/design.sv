`include "baudRateGenerator.v"
`ifdef UART_TX_ONLY
`include "uart_tx_controller.v"
`elsif UART_RX_ONLY
`include "uart_rx_controller.v"
`else
`include "uart_tx_controller.v"
`include "uart_rx_controller.v"
`endif


module uart_controller #(parameter CLOCK_RATE = 0,
                         parameter BAUD_RATE = 0,
                         parameter RX_OVERSAMPLE = 1)(
  
  input               clk,
  input               reset_n,
`ifdef UART_TX_ONLY
  input               i_Tx_Ready,
  input [7:0]         i_Tx_Byte,
  output              o_Tx_Active,
  output              o_Tx_Data,
  output              o_Tx_Done
`elsif UART_RX_ONLY
  input               i_Rx_Data,
  output              o_Rx_Done,
  output [7:0]        o_Rx_Byte
`else  
  input [7:0]         i_Tx_Byte,
  input               i_Tx_Ready,
  output              o_Rx_Done,  
  output [7:0]        o_Rx_Byte
  `endif
);
  
  wire                w_Rx_ClkTick, 
                      w_Tx_ClkTick;
  wire                w_Tx_Data_to_Rx;
  
  
`ifdef UART_TX_ONLY
  assign o_Tx_Data = w_Tx_Data_to_Rx;
`elsif UART_RX_ONLY
  assign w_Tx_Data_to_Rx = i_Rx_Data;
`endif
 
  
//Instantiate Baud Rate Generator 
  
  baudRateGenerator #(CLOCK_RATE, BAUD_RATE, RX_OVERSAMPLE) xbaudRateGenerator(
    
    .clk                (clk), 
    .reset_n            (reset_n), 
    .o_Rx_ClkTick       (w_Rx_ClkTick), 
    .o_Tx_ClkTick       (w_Tx_ClkTick)
  );
  
`ifdef UART_TX_ONLY
  
//Instantiation of TX Controller 
  uart_tx_controller xUART_TX(
    
    .clk                (w_Tx_ClkTick), 
    .reset_n            (reset_n), 
    .i_Tx_Byte          (i_Tx_Byte), 
    .i_Tx_Ready         (i_Tx_Ready), 
    .o_Tx_Done          (o_Tx_Done), 
    .o_Tx_Active        (o_Tx_Active), 
    .o_Tx_Data          (w_Tx_Data_to_Rx)
  );

`elsif UART_RX_ONLY
  
//Instantiation of RX Controller  
  uart_rx_controller #(RX_OVERSAMPLE) xUART_RX(
    
    .clk                (w_Rx_ClkTick), 
    .reset_n            (reset_n), 
    .i_Rx_Data          (w_Tx_Data_to_Rx), 
    .o_Rx_Done          (o_Rx_Done), 
    .o_Rx_Byte          (o_Rx_Byte)
  );
  
`else
  
//Instantiation of TX Controller 
  uart_tx_controller xUART_TX(
    
    .clk                (w_Tx_ClkTick), 
    .reset_n            (reset_n), 
    .i_Tx_Byte          (i_Tx_Byte), 
    .i_Tx_Ready         (i_Tx_Ready), 
    .o_Tx_Done          (), 
    .o_Tx_Active        (), 
    .o_Tx_Data          (w_Tx_Data_to_Rx)
  );
 
//Instantiation of RX Controller   
  uart_rx_controller #(RX_OVERSAMPLE) xUART_RX(
    
    .clk                (w_Rx_ClkTick), 
    .reset_n            (reset_n), 
    .i_Rx_Data          (w_Tx_Data_to_Rx), 
    .o_Rx_Done          (o_Rx_Done), 
    .o_Rx_Byte          (o_Rx_Byte)
  );
 
  `endif
  
 endmodule