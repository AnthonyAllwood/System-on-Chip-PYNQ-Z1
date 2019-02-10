//Testbench Code

`timescale 1ns/1ps

module thirtytwo_Mips_Testbench;
  
  //Inputs from main code
  reg reset;
  reg clock;
  
  //Outputs from main code
  //wire[31:0] pc_out;
  //wire[31:0] alu_result;
  wire [3:0]LEDs_out;
  
  //Unit Under Test
  thirtytwo_Mips uut (.SWITCH_in(1'b0),.LEDs_out(LEDs_out),.clock(clock),.reset(reset));//calls the main code file
  
  initial begin 
     
    clock = 0; //set clock equal to zero initially
    
    forever #10 clock = ~clock;//then set clock equal to 1 forever.  
    
  end 
  
  initial begin //Initialize post process debug using a vcd file
    
    $dumpfile ("dump.vcd"); //Contains variable definitions and value changes for all variables specified in task calls
    $dumpvars; //dumps all variables 
  
  end
  
  initial begin  //This initializes the inputs
    
    $monitor(clock);
    
    reset = 1; //set reset to 1
    
    #5 reset = 0; //after 0.5 nanoseconds, set reset to 0
    
    #1000 $finish; // After 200 nanoseconds, reset to finish
  
  end 
  
endmodule 
  