//Verilog Code for ALU control

`timescale 1ns/1ps

module alu_control(   
  input [1:0] aluop,//ALU operation selector input for instruction specification
  input [5:0] Function,//This is Instruction_Mem[5:0]
  output reg[2:0] ALU_Control //This will be the instruction selector for the ALU: add, sub, and, or, lw, sw, beq 
 );
  
  wire [7:0] ALUControlInput;
  assign ALUControlInput = {aluop, Function};//This is an 8 bit combintaion consisting of the 2 bits for ALUop and the 6 bits for ALU_function. This will make efficient selection for instruction specification
  
  always @(ALUControlInput)  
    begin
		case(ALUControlInput)
        
        8'b000000: begin
          					ALU_Control = 3'b000; //add
                     end 
        
        8'b000001: begin
          
          					ALU_Control = 3'b001; //sub 
        			 end 
        
        8'b000010: begin
          
          					ALU_Control = 3'b010; //and 
        			 end 
          
 		8'b000011: begin
          
          					ALU_Control = 3'b011; //or 
        			 end 
          
        8'b000100: begin 
          					ALU_Control = 3'b100; //slt
        		     end 
      
    	8'b11xxxx: begin
          
          					ALU_Control = 3'b000; //lw 
        			 end 
        
        8'b11xxxx: begin
          
          					ALU_Control = 3'b000; //sw 
        			 end 
     
        
        8'b01xxxx: begin
          
          					ALU_Control = 3'b001; //beq 
        			 end 
          
        default: begin
          					ALU_Control = 3'b000; //add
                   end 
        endcase
    end 
 
endmodule  