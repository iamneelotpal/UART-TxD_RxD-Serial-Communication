module uart_rx_controller #(parameter RX_OVERSAMPLE = 0)(
  
  input             clk,
  input             reset_n,
  input             i_Rx_Data,
  output            o_Rx_Done,  
  output [7:0]      o_Rx_Byte
);
  
localparam UART_RX_IDLE = 3'b000,
             UART_RX_START = 3'b001,
             UART_RX_DATA =  3'b010,
             UART_RX_STOP = 3'b011;
  
  reg [7:0]        r_Rx_Data;
  reg [2:0]        r_Bit_Index;
  reg [4:0]        r_Clk_Count;
  reg              r_Rx_Done;
  reg [2:0]        r_State;
  
   
//UART RX Logic Implementation 
  always @(posedge clk or negedge reset_n)
    begin
      if(~reset_n)
        begin
          r_State <= UART_RX_IDLE;          
          r_Bit_Index <= 0;
          r_Clk_Count <= 0;
          r_Rx_Done <= 1'b0;
          r_Rx_Data <= 8'b00;
        end
      else
    begin
      case(r_State)
        UART_RX_IDLE: begin      
          r_Bit_Index <= 0;
          r_Clk_Count <= 0;
          r_Rx_Done <= 1'b0;
          if(i_Rx_Data == 1'b0)
            begin
              r_State <= UART_RX_START;
            end
          else begin
            r_State <= UART_RX_IDLE;
          end
        end
        
        UART_RX_START: begin
          if(r_Clk_Count == RX_OVERSAMPLE/2)
            begin
              if(i_Rx_Data == 1'b0)
                begin
                  r_State <= UART_RX_DATA;
                  r_Clk_Count <= 0;
                end
              else begin
                  r_State <= UART_RX_IDLE;
              end
            end
          else begin
                  r_State <= UART_RX_START;
                  r_Clk_Count <= r_Clk_Count + 1;
          end
        end
        
        UART_RX_DATA: begin
          if(r_Clk_Count < (RX_OVERSAMPLE))
            begin
              r_State <= UART_RX_DATA;
              r_Clk_Count <= r_Clk_Count + 1;
            end
          else begin
              r_Rx_Data[r_Bit_Index] <= i_Rx_Data;
              r_Clk_Count <= 0;
            if(r_Bit_Index < 7 )
              begin
                r_Bit_Index <= r_Bit_Index + 1;
                r_State <= UART_RX_DATA;
              end
            else begin
                r_Bit_Index <= 0;
                r_State <= UART_RX_STOP;
            end
          end
        end
          
          UART_RX_STOP: begin
            if(r_Clk_Count < (RX_OVERSAMPLE))
              begin
                r_State <= UART_RX_STOP;
                r_Clk_Count = r_Clk_Count + 1;
              end
            else begin
              r_State <= UART_RX_IDLE;
              r_Clk_Count <= 0;
              r_Rx_Done <= 1'b1;
            end           
          end
          default: begin
              r_State <= UART_RX_IDLE;
          end
          endcase
     end
    end
  assign o_Rx_Done = r_Rx_Done;
  assign o_Rx_Byte = r_Rx_Done ? r_Rx_Data : 8'h00;
 endmodule