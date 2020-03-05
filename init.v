module init(clk, reset, gray_data, gray_valid, CNT1, CNT2, CNT3, CNT4, CNT5, CNT6, CNT_valid);

	input						clk, reset;
	input		[ 7:0]	gray_data;
	input 					gray_valid;
	
	output	[ 7:0]  CNT1;
	output	[ 7:0]  CNT2;
	output	[ 7:0]  CNT3;
	output	[ 7:0]  CNT4;
	output	[ 7:0]  CNT5;
	output	[ 7:0]  CNT6;

	output					CNT_valid;
	
	reg 		[ 7:0]	data[0:5];
	reg							CNT_valid;
	reg							flag;

	integer i;
	integer j;

	parameter n0 = 8'b00000000,
						n1 = 8'b00000001,
						n2 = 8'b00000010,
						n3 = 8'b00000011,
						n4 = 8'b00000100,
						n5 = 8'b00000101,
						n6 = 8'b00000110;
	
	assign CNT1 = CNT_valid ? data[0] : 8'bz;
	assign CNT2 = CNT_valid ? data[1] : 8'bz;
	assign CNT3 = CNT_valid ? data[2] : 8'bz;
	assign CNT4 = CNT_valid ? data[3] : 8'bz;
	assign CNT5 = CNT_valid ? data[4] : 8'bz;
	assign CNT6 = CNT_valid ? data[5] : 8'bz;

	always @(posedge clk) begin
		if(reset) begin
			flag <= 0;
		end
		else begin
			flag <= !(gray_valid || gray_data) ? 1: 0; 
		end
	end

	always @(posedge clk)	begin
		if(reset)	begin
			for(i=0; i<6; i=i+1)	begin
				data[i] <= 0;
			end
		end
		else	begin
			if(gray_valid == 1'b1)	begin
				case(gray_data)
					n1:	data[0]	<= data[0] + 1'b1;	 
					n2:	data[1]	<= data[1] + 1'b1;	
					n3: data[2]	<= data[2] + 1'b1;
					n4:	data[3]	<= data[3] + 1'b1;
					n5:	data[4]	<= data[4] + 1'b1;
					n6:	data[5]	<= data[5] + 1'b1; 
					default:	data[0] <= data[0]; 
				endcase
			end
			else begin
				data[0] <= data[0];
				data[1] <= data[1];
				data[2] <= data[2];
				data[3] <= data[3];
				data[4] <= data[4];
				data[5] <= data[5];
			end
		end
	end

	reg CNT_valid1;
	
	always@(posedge clk) begin
		if(reset)
			CNT_valid <= 1'b0;
		else 
			CNT_valid <= CNT_valid1;
	end

	always @(*)	begin
			if(flag)
				CNT_valid1 = 0;
			else	begin
				CNT_valid1 = !(gray_valid || gray_data) ? 1'b1 : 1'b0;
			end
	end


endmodule
