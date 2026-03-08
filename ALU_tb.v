module ALU_tb;
reg [7:0] a, b;
reg [2:0] opcode;
wire [15:0] result;
wire flagc, flagz;

reg [15:0] exp_result;
reg exp_flagc, exp_flagz;
integer i;
parameter [2:0] Add = 3'b000,
		Sub = 3'b001,
		Mul = 3'b010,
		And = 3'b011,
		Or  = 3'b100,
		Nand= 3'b101,
		Nor = 3'b110,
		Xor = 3'b111;


task check_output;
begin
	if({result, flagc, flagz} === {exp_result, exp_flagc, exp_flagz})
		$display("pass, time=%0t, result=%b, flagc=%b, flagz=%b, a=%b, b=%b, opcode=%b", $time, result, flagc, flagz, a, b, opcode);
	else
		 $display("fail, time=%0t, result=%b, flagc=%b, flagz=%b, a=%b, b=%b, opcode=%b", $time, result, flagc, flagz, a, b, opcode);
end
endtask

ALU dut(
	.a(a),
	.b(b),
	.opcode(opcode),
	.result(result),
	.flagc(flagc),
	.flagz(flagz)
);

initial 
begin
	a=$random;
	b=$random;
	
	for(i=0; i<8; i=i+1)
	begin
		opcode = i;
		exp_flagc = 1'b0;

		case(opcode)
			Add : 
			begin 
				{exp_flagc, exp_result[7:0]} = a+b;
				exp_result[15:8] = 8'b0;
			end
		
			Sub :
			begin 
				exp_result = {8'b0, a-b};
				exp_flagc = (a<b);
			end
				
			Mul : exp_result = a*b;
			And : exp_result = {8'b0, a&b};
			Or : exp_result = {8'b0, a|b};
			Nand : exp_result = {8'b0, ~(a&b)};
			Nor : exp_result = {8'b0, ~(a|b)};
			Xor : exp_result = {8'b0, a^b};

			default: exp_result = 16'b0;

		endcase
		exp_flagz = (exp_result == 16'b0);
		#5;
		check_output;
	end
	$finish;

end
endmodule


	