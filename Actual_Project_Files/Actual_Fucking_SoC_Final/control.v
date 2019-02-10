//Verilog Code for Control Unit 

`timescale 1ns/1ps

module control(
  input reset,
  input [5:0] control, //Control takes in the 6 bits from Instruction Memory(Instruction_Mem[31:26])
  output reg [1:0] reg_Dest,
  output reg branch,
  output reg mem_Read,
  output reg [1:0] memtoReg,
  output reg [1:0] aluop,
  output reg mem_Write,
  output reg reg_Write,
  output reg alu_Source,
  output reg sign_or_zero
);
  always @(*)
  begin
    if(reset == 1)
      begin 
        
     //Reg_dst, MemtoReg, and ALUop each receive 2-bit
     //Everything else is 1-bit
        
        	reg_Dest = 2'b00;
        	branch = 0;
        	mem_Read = 0;
        	memtoReg = 2'b00;
        	aluop = 2'b00;
        	mem_Write = 0;
        	reg_Write = 0;
        	alu_Source = 0;
        	sign_or_zero = 1'b1;
      end
    
    else
      begin
        case(control)
    
    //add, sub, and, & or are all R-type
    //lw, sw, & beq are all I-types but the bit format for control [5:0] are different.
        
		
        6'b000: begin // add, sub, and, or 
                reg_Dest = 2'b01;  
                memtoReg = 2'b00;  
                aluop = 2'b00;  
                branch = 1'b0;  
				mem_Read = 1'b0;  
				mem_Write = 1'b0;  
                alu_Source = 1'b0;  
                reg_Write = 1'b1;  
                sign_or_zero = 1'b1;  
                end
         
        6'b100: begin // lw  
                reg_Dest = 2'b00;                 
				memtoReg = 2'b01;  
                aluop = 2'b11;  
                branch = 1'b0;                 
				mem_Read = 1'b1;                 
				mem_Write = 1'b0;  
                alu_Source = 1'b1;  
                reg_Write = 1'b1;  
                sign_or_zero = 1'b1;  
                end 
        
        6'b101: begin // sw  
                reg_Dest = 2'b00;                  
				memtoReg = 2'b00;  
                aluop = 2'b11;   
                branch = 1'b0;                 
				mem_Read = 1'b0;                 
				mem_Write = 1'b1;  
                alu_Source = 1'b1;  
                reg_Write = 1'b0;  
                sign_or_zero = 1'b1;  
                end  
        6'b110: begin // beq  
                reg_Dest = 2'b00;                 
				memtoReg = 2'b00;  
                aluop = 2'b01;  
                branch = 1'b1;                 
				mem_Read = 1'b0;                 
				mem_Write = 1'b0;  
                alu_Source = 1'b0;  
                reg_Write = 1'b0;  
                sign_or_zero = 1'b1;  
                end
        
        6'b111: begin // addi  
                reg_Dest = 2'b00;                 
				memtoReg = 2'b00;  
                aluop = 2'b11;  
                branch = 1'b0;                 
				mem_Read = 1'b0;  
                mem_Write = 1'b0;  
                alu_Source = 1'b1;  
                reg_Write = 1'b1;  
                sign_or_zero = 1'b1;  
                end
        
       default: begin  
                reg_Dest = 2'b01;                  
				memtoReg = 2'b00;  
                aluop = 2'b00;  
                branch = 1'b0;                  
				mem_Read = 1'b0;  
				mem_Write = 1'b0;  
                alu_Source = 1'b0;  
                reg_Write = 1'b1;  
                sign_or_zero = 1'b1;
       			end
     endcase 
  end 
 end 

endmodule 
