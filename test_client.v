

module test_client(
  input i_clk,
  input i_rst,
  input i_startTest,
  
  input i_serverBusy,
  input i_dataValid,
  input i_readData,
  output reg o_command,
  output reg o_writeElseRead,
  output reg [1:0] o_commandSize,
  output reg [14:0] o_targetAddr,
  output reg [2:0] o_subAddr,
  output wire o_ready
  //output reg [15:0] o_writeMask,
  //output reg [255:0] o_writeData
);

reg [7:0] state;
reg [31:0] cooldownCounter;
reg timerOn;

assign o_ready = (cooldownCounter == 32'h0000_0000) ? 1'b1 : 1'b0;

always @ (posedge i_clk or negedge i_rst)
begin
  if (!i_rst)
  begin
    state <= 8'h00;
    o_command <= 1'b0;
    o_writeElseRead <= 1'b1;  // Set to 1 since first command is a write
    o_commandSize <= 2'b00;
    o_targetAddr <= 15'b0;
    o_subAddr <= 3'b000;
  end
  else
  begin
    case (state)
      8'h00:begin
        o_command <= 1'b0; 
        
        if (i_startTest && (cooldownCounter == 32'h0))
        begin
          state <= 8'h01;
        end
        else
        begin
          state <= state;
        end
      end
      
      8'h01:begin
        // 256-bit write to address 0x0
        o_writeElseRead <= 1'b1;
        o_commandSize <= 2'b10;
        o_targetAddr <= 15'b0;
        o_subAddr <= 3'b000;
        if (!i_serverBusy)
        begin
          o_command <= 1'b1;
          state <= 8'h02;
        end
        else
        begin
          o_command <= 1'b0;
          state <= state;
        end
      end
      
      8'h02:begin
        // Buffer stage to prevent i_command high two cycles in a row
        o_command <= 1'b0;
        state <= 8'h03;
      end
      
      8'h03:begin
        // 256-bit read address 0x0
        o_writeElseRead <= 1'b0;
        o_commandSize <= 2'b10;
        o_targetAddr <= 15'b0;
        o_subAddr <= 3'b000;
      
        if(!i_serverBusy)
        begin
          o_command <= 1'b1;
          state <= 8'h04;
        end
        else
        begin
          o_command <= 1'b0;
          state <= state;
        end
      end
      
      8'h04:begin
        // Buffer stage to prevent i_command high two cycles in a row
        o_command <= 1'b0;
        state <= 8'h05;
      end
      
      8'h05:begin
        // 64-bit write to address 0x2
        o_writeElseRead <= 1'b1;
        o_commandSize <= 2'b01;
        o_targetAddr <= 15'b0;
        o_subAddr <= 3'b010;
        
        if(!i_serverBusy)
        begin
          o_command <= 1'b1;
          state <= 8'h06;
        end
        else
        begin
          o_command <= 1'b0;
          state <= state;
        end
      end
      
      8'h06:begin
        // Buffer stage to prevent i_command high two cycles in a row
        o_command <= 1'b0;
        state <= 8'h07;
      end
      
      8'h07:begin
        // 32-bit write to address 0x5
        o_writeElseRead <= 1'b1;
        o_commandSize <= 2'b00;
        o_targetAddr <= 15'b0;
        o_subAddr <= 3'b101;
        
        if(!i_serverBusy)
        begin
          o_command <= 1'b1;
          state <= 8'h08;
        end
        else
        begin
          o_command <= 1'b0;
          state <= state;
        end
      end
      
      8'h08:begin
        // Buffer stage to prevent i_command high two cycles in a row
        o_command <= 1'b0;
        state <= 8'h09;
      end
      
      8'h09:begin
        // 256-bit write to address 0x7
        o_writeElseRead <= 1'b1;
        o_commandSize <= 2'b10;
        o_targetAddr <= 15'b0;
        o_subAddr <= 3'b111;
        
        if (!i_serverBusy)
        begin
          o_command <= 1'b1;
          state <= 8'h0A;
        end
        else
        begin
          o_command <= 1'b0;
          state <= state;
        end
      end
      
      8'h0A:begin
        // Buffer stage to prevent i_command high two cycles in a row
        o_command <= 1'b0;
        state <= 8'h0B;
      end
      
      8'h0B:begin
        // 256-bit write to address 0xF
        o_writeElseRead <= 1'b1;
        o_commandSize <= 2'b10;
        o_targetAddr <= 15'b1;
        o_subAddr <= 3'b111;
        
        if (!i_serverBusy)
        begin
          o_command <= 1'b1;
          state <= 8'h0C;
        end
        else
        begin
          o_command <= 1'b0;
          state <= state;
        end
      end
      
      8'h0C:begin
        // Buffer stage to prevent i_command high two cycles in a row
        o_command <= 1'b0;
        state <= 8'h0D;
      end
      
      8'h0D:begin
        // 256-bit read address 0x0
        o_writeElseRead <= 1'b0;
        o_commandSize <= 2'b10;
        o_targetAddr <= 15'b0;
        o_subAddr <= 3'b000;
      
        if(!i_serverBusy)
        begin
          o_command <= 1'b1;
          state <= 8'h0E;
        end
        else
        begin
          o_command <= 1'b0;
          state <= state;
        end
      end
      
      8'h0E:begin
        // Buffer stage to prevent i_command high two cycles in a row
        o_command <= 1'b0;
        state <= 8'h0F;
      end
      
      8'h0F:begin
        // 256-bit read address 0x8
        o_writeElseRead <= 1'b0;
        o_commandSize <= 2'b10;
        o_targetAddr <= 15'b1;
        o_subAddr <= 3'b000;
      
        if(!i_serverBusy)
        begin
          o_command <= 1'b1;
          state <= 8'h10;
        end
        else
        begin
          o_command <= 1'b0;
          state <= state;
        end
      end
      
      8'h10:begin
        // Buffer stage to prevent i_command high two cycles in a row
        o_command <= 1'b0;
        state <= 8'h11;
      end
      
      8'h11:begin
        // 256-bit read address 0x10
        o_writeElseRead <= 1'b0;
        o_commandSize <= 2'b10;
        o_targetAddr <= 15'b10;
        o_subAddr <= 3'b000;
      
        if(!i_serverBusy)
        begin
          o_command <= 1'b1;
          state <= 8'h12;
        end
        else
        begin
          o_command <= 1'b0;
          state <= state;
        end
      end
      
      8'h12:begin
        // Buffer stage to prevent i_command high two cycles in a row
        o_command <= 1'b0;
        state <= 8'h13;
      end
      
      8'h13:begin
        // 256-bit read address 0x18
        o_writeElseRead <= 1'b0;
        o_commandSize <= 2'b10;
        o_targetAddr <= 15'b11;
        o_subAddr <= 3'b000;
      
        if(!i_serverBusy)
        begin
          o_command <= 1'b1;
          state <= 8'h00;
        end
        else
        begin
          o_command <= 1'b0;
          state <= state;
        end
      end
    endcase
  end
end

// cooldownCounter logic
always @ (posedge i_clk or negedge i_rst)
begin
  if (!i_rst)
  begin
    cooldownCounter <= 32'h0200_0000;
  end
  else
  begin
    if (i_startTest)
    begin
      cooldownCounter <= 32'h0200_0000;
    end
    else
    begin
      if (cooldownCounter != 32'h0000_0000)
      begin
        cooldownCounter <= cooldownCounter - 32'h0000_0001;
      end
      else
      begin
        cooldownCounter <= cooldownCounter;
      end
    end
  end
end

endmodule
