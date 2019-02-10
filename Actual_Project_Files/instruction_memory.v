      `timescale 1ns/1ps
      
      module instruction_memory
        (
          input[31:0] pc,
          output wire[31:0] instruction
        );
        
        wire [3 : 0] rom_Addr = pc[5 : 2];
        
        reg[31:0] format[3:0];
        
            initial 
            begin 

/*add instructions for LEDs_out*/

            //add
              format[0] = 32'b00000000000001000001100000000000; 
            
            //add
              format[1] = 32'b00000000000001010001100000000000;
       
            //add
              format[2] = 32'b00000000000001100001100000000000;
         
            //add
              format[3] = 32'b00000000000001110001100000000000;
                          
            end 
        
            //Use of tenary operator instead of an if-else statement
        assign instruction = (pc[31:0] < 32 ) ? format[rom_Addr[3:0]] : 32'd0;
        
        //Equivalent to:
        
        /*if(pc < 32)
          begin
              assign instruction = format[rom_Addr[3:0]];
          end
        else 
          begin
              assign instruction = 32'd0;
          end
        */
        
      endmodule