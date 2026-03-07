module ALU(
	input [7:0] a, b,
	input [2:0] opcode,
	output reg [15:0] result,
	output reg flagc, flagz
);


parameter [2:0] Add = 3'b000,
		Sub = 3'b001,
		Mul = 3'b010,
		And = 3'b011,
		Or  = 3'b100,
		Nand= 3'b101,
		Nor = 3'b110,
		Xor = 3'b111;

always @(*)
begin

	flagc = 1'b0;

	case(opcode)
		Add : 
		begin 
			{flagc, result[7:0]} = a+b;
			result[15:8] = 8'b0;
		end
		
		Sub :
		begin 
			result = {8'b0, a-b};
			flagc = (a<b);
		end
				
		Mul : result = a*b;
		And : result = {8'b0, a&b};
		Or : result = {8'b0, a|b};
		Nand : result = {8'b0, ~(a&b)};
		Nor : result = {8'b0, ~(a|b)};
		Xor : result = {8'b0, a^b};

		default: result = 16'b0;

	endcase
	flagz = (result == 16'b0);
end
endmodule









