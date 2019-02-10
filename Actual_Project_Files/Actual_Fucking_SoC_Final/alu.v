//Verilog Code for Arithmetic Loguc Unit 

`timescale 1ns/1ps

module alu(
  
  input[31:0] firstValue,
  input[31:0] secondValue,
  input[2:0] alu_control, //function select
  output reg[31:0] result, //result
  output zero_flag
);
  
  always @(*)
    begin
      case (alu_control)
        
        3'b000: begin result = firstValue + secondValue; end  //selects add instruction (lw, sw)
        3'b001: begin result = firstValue - secondValue; end  //selects sub instruction (beq)
        3'b010: begin result = firstValue & secondValue; end  //selects and instruction
        3'b011: begin result = firstValue | secondValue; end  //selects or instruction
        3'b100: begin 
          				if(firstValue < secondValue)
            			begin 
            					result = 32'd1; //negative
            			end 
          				else 
            			begin 
              					result = 32'd0;
            			end 
        		end 
        default: begin 
          				result = firstValue + secondValue; //add instruction
        		 end 
          
      endcase
    end 
        
  assign zero_flag = (result == 32'd0) ? 1'b1 : 1'b0; //if the result comes out to be a 32- bit representation of zero
  
  /*Equivalent to: 
  
  if (Result_ALU == 32'd0) //if the result comes out to be a 32- bit representation of zero
      begin 
        	assign Zer0_flag = 1;
      end
    
    else
      begin 
        	assign Zer0_flag = 0;
      end
  */
    
endmodule 