module cb(clk, reset, CNT1, CNT2, CNT3, CNT4, CNT5, CNT6, CNT_valid, code_valid, HC1, HC2, HC3, HC4, HC5, HC6, M1, M2, M3, M4, M5, M6);

	input					  clk, reset;
	
	input	 [ 7:0]   CNT1;
	input	 [ 7:0]   CNT2;
	input	 [ 7:0]   CNT3;
	input	 [ 7:0]   CNT4;
	input	 [ 7:0]   CNT5;
	input	 [ 7:0]   CNT6;
	input					  CNT_valid;
	
	output				  code_valid;
	output [ 7:0]   HC1;
	output [ 7:0]   HC2;
	output [ 7:0]   HC3;
	output [ 7:0]   HC4;
	output [ 7:0]   HC5;
	output [ 7:0]   HC6;
	
	output [ 7:0]   M1;
	output [ 7:0]   M2;
	output [ 7:0]   M3;
	output [ 7:0]   M4;
	output [ 7:0]   M5;
	output [ 7:0]   M6;
	
	reg		 [ 7:0]	  rec	  [0:4] [0:1];							// activation record for combonition	+----little----+----big----+
	reg		 [ 7:0]	  data	[0:5]	[0:1];							// array during sorting
	reg		 [ 7:0]   index [0:5];
	reg    [ 7:0]   hc		[0:5];
	reg    [ 7:0]   mask	[0:5];

	reg						  in_valid;												
	reg		 [ 2:0]	  sort_cnt;												// if sort_cnt == 6, sort finished
	reg						  sort_idx;												// cycle control

	reg		 [ 2:0]   rec_ctrl;
	reg		 [ 2:0]	  cb_ctrl;
	reg 						code_valid;

	wire					  rec_valid;
	wire					  out_valid;

	integer i;
	integer	j;
	integer k;

	assign rec_valid = data[5][1] == 100 ? 1 : 0;
	assign out_valid = sort_cnt == 7 && sort_idx ? 1 : 0;

	assign HC1 = code_valid ? hc[0]: 8'bz;
	assign HC2 = code_valid ? hc[1]: 8'bz;
	assign HC3 = code_valid ? hc[2]: 8'bz;
	assign HC4 = code_valid ? hc[3]: 8'bz;
	assign HC5 = code_valid ? hc[4]: 8'bz;
	assign HC6 = code_valid ? hc[5]: 8'bz;
	assign M1  = code_valid ? mask[0]: 8'bz;
	assign M2  = code_valid ? mask[1]: 8'bz;
	assign M3  = code_valid ? mask[2]: 8'bz;
	assign M4  = code_valid ? mask[3]: 8'bz;
	assign M5  = code_valid ? mask[4]: 8'bz;
	assign M6  = code_valid ? mask[5]: 8'bz;

	always @(posedge clk)	begin
		if(reset)	begin
			for (i=0; i<6; i=i+1)	begin
				data[i][0] <= {7'b0, 1'b1} << i;
				index[i] <= {7'b0, 1'b1} << i;
			end
		end
		else	if(CNT_valid) begin
			data[0][1] <= CNT1;	
			data[1][1] <= CNT2;	
			data[2][1] <= CNT3;	
			data[3][1] <= CNT4;	
			data[4][1] <= CNT5;	
			data[5][1] <= CNT6;	
		end
	end
	
	always @(posedge clk)	begin
		if(reset)
			in_valid <= 0;
		else
			in_valid <=	CNT_valid ? CNT_valid : in_valid; 
	end

	always @(posedge clk)	begin
		if(reset)	begin
			sort_cnt <= 0;		
		end
		else	if(in_valid) begin
			sort_cnt <= (sort_cnt == 7) ? 0 : sort_cnt + 1;
		end
	end

	always @(posedge clk)	begin
		if(reset)	begin
			sort_idx <= 0;	
		end
		else if(in_valid)	begin
			sort_idx <= ~sort_idx;
		end
	end

	/* Sorting */
	always @(posedge clk)	begin
		if(sort_cnt!=7 && ~sort_idx)	begin
			for (i=0; i<6; i=i+2)	begin
				if	(data[i][1] > data[i+1][1])	begin
					for (j=0; j<2; j=j+1)	begin
						data[i  ][j] <= data[i+1][j];
						data[i+1][j] <=	data[i  ][j];
					end
				end
				else	begin
					for (j=0; j<2; j=j+1)	begin
						data[i  ][j] <= data[i  ][j];
						data[i+1][j] <=	data[i+1][j];
					end
				end
			end
		end
		else	if(sort_cnt!=7 && sort_idx)	begin
			for(i=1; i<5; i=i+2)	begin
				if	(data[i][1] > data[i+1][1])	begin
					for (j=0; j<2; j=j+1)	begin
						data[i  ][j] <= data[i+1][j];
						data[i+1][j] <=	data[i  ][j];
					end
				end
				else	begin
					for (j=0; j<2; j=j+1)	begin
						data[i  ][j] <= data[i  ][j];
						data[i+1][j] <=	data[i+1][j];
					end
				end
			end
		end
	end
	
	/* Adjust array */
	always @(posedge clk)	begin
		if(reset)	begin
			cb_ctrl <= 1;
			for(i=0; i<6;i=i+1)	begin
				for(j=0; j<2; j=j+1)	begin
					rec[i][j] <= 8'b0;
				end
			end
		end
		else if(out_valid && !rec_valid)	begin
			 data[cb_ctrl][0] <= data[cb_ctrl-1][0] | data[cb_ctrl][0];
			 data[cb_ctrl][1] <= data[cb_ctrl-1][1] + data[cb_ctrl][1];
			 data[cb_ctrl-1][0] <= 0;
			 data[cb_ctrl-1][1] <= 0;
			 rec[cb_ctrl-1][0] <= data[cb_ctrl-1][0]; 
			 rec[cb_ctrl-1][1] <= data[cb_ctrl][0]; 
			 cb_ctrl <= cb_ctrl +1;
		end
	end

	always @(posedge clk)	begin
		if(reset)	begin
			rec_ctrl <= 5;		
		end
		else if(cb_ctrl == 6)begin
			rec_ctrl <= code_valid ? 7 : rec_ctrl - 1;
		end
	end

	always @(posedge clk)	begin
		if(reset)	begin
			code_valid <= 0;		
		end
		else begin 
			if(rec_ctrl == 0)begin
				code_valid <= 1;
			end
			else 
				code_valid <=0;
		end
	end
	
	/* Split */
	always @(posedge clk)	begin
		if(reset)	begin
			for(i=0; i<7; i=i+1)	begin
				hc[i] = 8'b0;
				mask[i] = 8'b0;
			end
		end
		else if(rec_valid)	begin
			for(k=0; k<7; k=k+1)	begin
				if(rec[rec_ctrl][0] & index[k])	begin
					hc[k] = {hc[k][6:0], 1'b1};
					mask[k] = {mask[k], 1'b1};
				end
				else begin
					hc[k] = hc[k];
					mask[k] = mask[k];
				end
				if(rec[rec_ctrl][1] & index[k])	begin
					hc[k] = hc[k] << 1;
					mask[k] = {mask[k], 1'b1};
				end
				else begin
					hc[k] = hc[k];
					mask[k] = mask[k];
				end
			end
		end
	end



endmodule
