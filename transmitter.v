module transmitter(
	
	input clk, wr_enb, rst, enb,
	input [7:0] data_in,
	output reg tx, 
	output busy
);

parameter idle_state = 2'b00,
	  start_state = 2'b01,
	  data_state = 2'b10,
	  stop_state = 2'b11;

reg [7:0] data;
reg [2:0] index;
reg [1:0] state = 2'b11;

always @(posedge clk or posedge rst)
	begin
	  if(rst)
	    begin
		tx <= 1'b1;
		state <= idle_state;
	    end
	  else
	    begin
		case(state)

		idle_state : 
		  begin
			if(wr_enb)
			  begin 
				state <= start_state;
				data <= data_in;
				index <= 3'h0;
			  end
			else
				state <= idle_state;
		  end

		start_state:
		  begin
			if(enb)
			  begin
				tx<=1'b0;
				state <= data_state;
			  end
			else
			  	state <= start_state;
		  end

		data_state: 
		  begin
			if(enb)
			  begin
				
				tx <= data[index];
				
				if(index == 3'h7)
					state <= stop_state;
				else 
					index <= index + 1;
			end
		  end

		stop_state:
		  begin
			if(enb)
				begin
					tx<=1'b1;
					state <= idle_state;
				end
		  end
		
		default : 
		  begin
			tx<=1'b1;
			state<=idle_state;
		  end
	endcase

	    end
end

assign busy = (state != idle_state);

endmodule 
		
		
				
