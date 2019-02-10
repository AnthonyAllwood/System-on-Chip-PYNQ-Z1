//Verilog Code for Register File 

`timescale 1ns/1ps


module register_file  
 (  
      input clock,  
      input reset,   
   	  input [4:0] reg_read_Addr_1,  
      output[31:0] reg_read_Data_1, 
      input [4:0] reg_read_Addr_2,  
      output[31:0] reg_read_Data_2,
   	  input reg_write_En,  
      input[4:0] reg_write_Dest,  
   	  input[31:0] reg_write_Data,
   	  output reg [3:0]LED_state
 );  
  reg[31:0] reg_Array [18:0];  

  always @ (posedge clock or posedge reset) 
      begin  
        if(reset == 1) 
          begin 
 		  reg_Array[0] = 32'b0;
          
          //add		      
          reg_Array[1] = 32'b00000000000000000000000000000000; 
          reg_Array[2] = 32'b00000000000000000000000000000000;
          reg_Array[3] = 32'b00000000000000000000000000000000;           
          reg_Array[4] = 32'b00000000000000000000000000001000; 
          reg_Array[5] = 32'b00000000000000000000000000000100; 
          reg_Array[6] = 32'b00000000000000000000000000000010; 
          reg_Array[7] = 32'b00000000000000000000000000000001; 
          reg_Array[8] = 32'b00000000000000000000000000001111; 
          reg_Array[9] = 32'b00000000000000000000000000000000;       
          reg_Array[10] = 32'b00000000000000000000000000000000;
          reg_Array[11] = 32'b00000000000000000000000000000000; 
          reg_Array[12] = 32'b00000000000000000000000000000000;               
          reg_Array[13] = 32'b00000000000000000000000000000000; 
          reg_Array[14] = 32'b00000000000000000000000000000000;                       
          reg_Array[15] = 32'b00000000000000000000000000000000; 
          reg_Array[16] = 32'b00000000000000000000000000000000;                              
          reg_Array[15] = 32'b00000000000000000000000000000000; 
          reg_Array[16] = 32'b00000000000000000000000000000000;
        end
           else 
             begin  
               LED_state <= reg_Array[3][3:0];
               		if(reg_write_En) 
                	begin  
                      	reg_Array[reg_write_Dest] <= reg_write_Data;  
             		end  
           	 end  
      end  
      
  assign reg_read_Data_1 = (reg_read_Addr_1 == 0)? 32'b0 : reg_Array[reg_read_Addr_1];  
  assign reg_read_Data_2 = (reg_read_Addr_2 == 0)? 32'b0 : reg_Array[reg_read_Addr_2];  
  
  /*Equivalent to:
  
  if (Read_register_1 == 0)
      begin 
        	assign Read_data_1 = REGISTER_array[Read_register_1];
      end
    else
      begin
        	assign Read_data_1 = 32'b0;
      end 
    
    if (Read_register_2 == 1)
      begin 
        	assign Read_data_2 = REGISTER_array[Read_register_2];
      end
    else
      begin
        	assign Read_data_2 = 32'b0;
      end 
  */
 
endmodule   