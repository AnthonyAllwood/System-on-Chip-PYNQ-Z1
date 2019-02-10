//Verilog Code for Data Memory

`timescale 1ns/1ps

module data_memory
 (
  	input clock,     
  	input[31:0] mem_write_Data,
    input[31:0] mem_access_Addr,  
  	input mem_Read,
    input mem_write_En,
  	output [31:0] mem_read_Data  
 );   
  
  reg[31:0] ram[255:0];
  
  wire [7 : 0] ram_Addr = mem_access_Addr[8 : 1];
  
  //Establish a way to iterate through the Random_Access_Mem array:
  
  integer x; 
  
  initial begin  
    for(x = 0; x < 256; x = x + 1)  
      		
      	ram[x] <= 32'd0;  
  	
  	end  
  
  always @(posedge clock) 
    begin  
      if (mem_write_En == 1)  
        	
        	ram[ram_Addr] <= mem_write_Data;  
    end  
  
  assign mem_read_Data = (mem_Read==1'b1) ? ram[ram_Addr]: 32'd0;   

endmodule 