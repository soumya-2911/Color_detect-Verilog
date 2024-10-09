

module color_detect (
    input  clk_1MHz, cs_out,
    output reg [1:0] filter, color
);

// red   -> color = 1;
// green -> color = 2;
// blue  -> color = 3;

	reg [9:0] red_cnt=0;
	reg [9:0] green_cnt=0;
	reg [9:0] blue_cnt=0;
	reg [9:0] clk_cnt=0;

initial begin 
    filter = 2; color = 0;
end



//counter 1
always @(posedge clk_1MHz) begin
	clk_cnt = clk_cnt+1;
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
                    if (red_cnt >= blue_cnt && red_cnt >= green_cnt)  
                        color=1;
                    else if (blue_cnt >= red_cnt && blue_cnt >= green_cnt)
                        color=3;
                    else if (green_cnt >= red_cnt && green_cnt >= blue_cnt)
                        color=2;

                end
            endcase
        end
    end
	 
end
always @(posedge cs_out) begin
	
	//
	
		case (filter)
			1: begin
				
				blue_cnt =blue_cnt+1;
				
			end
			0: begin
				
				red_cnt= red_cnt+1;
				
			end
			3: begin
				
				green_cnt =green_cnt+1;
				
			end
         2: begin
               
                    //
						red_cnt=0;
						blue_cnt=0;
						green_cnt=0;
            end
		endcase
	
	

end
endmodule
