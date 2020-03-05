`include "init.v"
`include "cb.v"

module huffman(clk, reset, gray_valid, gray_data, CNT_valid, CNT1, CNT2, CNT3, CNT4, CNT5, CNT6,
    code_valid, HC1, HC2, HC3, HC4, HC5, HC6, M1, M2, M3, M4, M5, M6);

	input 				  clk;
	input 				  reset;
	input 				  gray_valid;
	input 	[ 7:0]  gray_data;
	output 				  CNT_valid;
	output 	[ 7:0]  CNT1, CNT2, CNT3, CNT4, CNT5, CNT6;
	output 				  code_valid;
	output 	[ 7:0]  HC1, HC2, HC3, HC4, HC5, HC6;
	output 	[ 7:0]  M1, M2, M3, M4, M5, M6;

init	init(
	.clk					(clk), 
	.reset				(reset), 
	.gray_data		(gray_data), 
	.gray_valid		(gray_valid), 
	.CNT1					(CNT1), 
	.CNT2					(CNT2), 
	.CNT3					(CNT3), 
	.CNT4					(CNT4), 
	.CNT5					(CNT5), 
	.CNT6					(CNT6), 
	.CNT_valid		(CNT_valid)
);


cb	cb(
	.clk					(clk), 
	.reset				(reset), 
	.CNT1					(CNT1), 
	.CNT2					(CNT2), 
	.CNT3					(CNT3), 
	.CNT4					(CNT4), 
	.CNT5					(CNT5), 
	.CNT6					(CNT6), 
	.CNT_valid		(CNT_valid),
	.code_valid   (code_valid),
	.HC1					(HC1),
	.HC2					(HC2),
	.HC3					(HC3),
	.HC4					(HC4),
	.HC5					(HC5),
	.HC6					(HC6),
	.M1						(M1),
	.M2						(M2),
	.M3						(M3),
	.M4						(M4),
	.M5						(M5),
	.M6						(M6)
);


endmodule

