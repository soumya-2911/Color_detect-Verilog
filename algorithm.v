
//Inputs : clk_1MHz, cs_out
//Output : filter, color



module t1b_cd_fd (
    input  clk_1MHz, cs_out,
    output reg [1:0] filter, color
);

// red   -> color = 1;
// green -> color = 2;
// blue  -> color = 3;

	reg [8:0] red_cnt=0;
	reg [8:0] green_cnt=0;
	reg [8:0] blue_cnt=0;
	reg [8:0] clk_cnt=0;
	reg flag=0;

initial begin 
    filter = 2; color = 0;
end

//counter 1
always @(posedge clk_1MHz) begin
	clk_cnt = clk_cnt+1;
	flag=0;
    if(filter==2) begin
        if(clk_cnt>0) begin
            
            clk_cnt=0;
            filter=3;
        end
    end
    else begin
        if(clk_cnt>499) begin
		  
				clk_cnt=0;
            case(filter)
                3: begin
                    filter=0;
                    
                end
                0: begin
                    filter=1;
                    

                end
                1: begin
                    filter=2;
                    if (red_cnt > blue_cnt && red_cnt > green_cnt) begin
        color = 1;  // Red has the highest frequency
    end
    else if (blue_cnt > red_cnt && blue_cnt > green_cnt) begin
        color = 3;  // Blue has the highest frequency
    end
    else if (green_cnt > red_cnt && green_cnt > blue_cnt) begin
        color = 2;  // Green has the highest frequency
    end
    else begin
        color = 0;  // Default case if counts are equal or undefined
    end
						flag =1;
                end
            endcase
        end
    end
	 
end
always @(posedge cs_out or posedge flag) begin
	
	//
        
		case (filter)
			1: begin
				if(clk_cnt==150) begin
				blue_cnt =blue_cnt+1;
                end
			end
			0: begin
				if(clk_cnt==150) begin
				red_cnt= red_cnt+1;
                end
			end
			3: begin
				if(clk_cnt==150) begin
				green_cnt =green_cnt+1;
                end
				
			end
         2: begin
                //max of cnts
                     // Otherwise, c is the largest
                    //
						  if(flag) begin
						red_cnt=0;
						blue_cnt=0;
						green_cnt=0;
						end
            end
		endcase
	
	

end


endmodule
