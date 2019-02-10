//32 Bit MIPS Processor Design using Verilog code

`include "instruction_memory.v"
`include "control.v"
`include "register_file.sv"
`include "alu_control.v"
`include "alu.v"
`include "data_memory.v"

`timescale 1ns/1ps

module thirtytwo_Mips(
  input clock,
  input reset,
  output [3:0]LEDs_out,
  input SWITCH_in
  //output[31:0] pc_out, 
  //output[31:0] alu_result
);

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  //PROGRAM COUNTER
  
  wire signed[31:0] imm_Shift_2;
  wire signed[31:0] pc_Beq;
  wire signed[31:0] pc_4Beq;
  wire signed[31:0] no_sign_Ext;
  wire beq_Control;
  reg[31:0] pc_Current;
  wire[31:0] pc_Next;
  wire[31:0] pc_Plus4;
  
  // pc + 4
  assign pc_Plus4 = pc_Current + 32'd4;
  
  //Sign Extend
  wire [31:0] sign_ext_Imm;
  assign sign_ext_Imm = {{16{instruct[15]}},instruct[15:0]}; //The most significant bit of Instruction_mem(bit 15) is shifted and copied 16 bits to the left; 16 bit is extended to 32 bit. The 32 bit extension is then sent to immediate shift.

  // Immediate Shift 
  assign imm_Shift_2 = {sign_ext_Imm[29:0],2'b0};
  assign no_sign_Ext = ~(imm_Shift_2) + 1'b1; //Shift left 2; Shifts in 2 zeros.

  // BEQ 
  
  // pc_Beq
  assign pc_Beq = (imm_Shift_2[15] == 1'b1) ? (pc_Plus4 - no_sign_Ext): (pc_Plus4 + imm_Shift_2);
 
  // beq control
  assign beq_Control = branch & zero_flag;
 
  // PC_beq (Multiplexer for PC)
  assign pc_4Beq = (beq_Control==1'b1) ? pc_Beq : pc_Plus4;
  
  /*Equivalent to: 
  
  if (beq_Control == 1)
  {
    pc_4Beq = pc_Beq;
  }
  else
  {
    pc_4Beq = pc_Plus4;
  }
  */

  //pc_Next
  assign pc_Next = pc_4Beq;
  
  //Output 
  wire [31:0] pc_out = pc_Current; //GND
  wire [31:0] alu_result = alu_out; //GND

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
  
 //INSTRUCTION MEMORY
  
  wire [31:0] instruct;//Comes out from instruction memory component
  
  instruction_memory instruction_memory(.pc(pc_Current),.instruction(instruct));

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
 //CONTROL UNIT 
  
 //Wires going into Instruction memory
   wire [31:0] instr;
  
  //2-bit wires from control
  wire[1:0] reg_Dest;
  wire[1:0] memtoReg;
  wire[1:0] aluop;
  
 //1-bit wires from control
  wire branch;
  wire mem_Read;
  wire mem_Write;
  wire alu_Source;
  wire reg_Write; 
  wire sign_or_zero;
  
  //Instruction_mem[31:26] goes into Control Unit
  //Control Unit "outputs": reg_Dest, branch, mem_Read, memtoReg, aluop, mem_Write, reg_Write, and alu_Source
  //Each declared and initialized in "CONTROL" module
  
  //Control Unit
  control control(.reset(reset),.control(instruct[31:26]),.reg_Dest(reg_Dest),.memtoReg(memtoReg),.aluop(aluop),.branch(branch),.mem_Read(mem_Read),.mem_Write(mem_Write),.alu_Source(alu_Source),.reg_Write(reg_Write),.sign_or_zero(sign_or_zero));
  
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
  
  //REGISTER FILE
  
  //instruct[25:21], [20:16], and [15:11] goes into register component.
  
  wire [4:0]  reg_write_Dest;
  wire [31:0] reg_write_Data;
  wire [4:0]  reg_read_Addr_1;
  wire [4:0]  reg_read_Addr_2;
  wire [31:0] reg_read_Data_1;
  wire [31:0] reg_read_Data_2;
  
  //Multiplexer for Write Register
  //Use of Ternary Operator
  assign reg_write_Dest = (reg_Dest==2'b1) ?  instruct[15:11] : instruct[20:16]; 
  
    //Equivalent to: 
  
  /*
  
  if(reg_Dest //from control unit// == 2'b1)
  	begin
    	reg_write_Dest = instruct[15:11];
  	end
  else
  	begin
    	reg_write_Dest = instruct[20:16];
    end
 */ 
  
   //Register file
   assign reg_read_Addr_1 = instruct[25:21];
   assign reg_read_Addr_2 = instruct[20:16];
  
  register_file register_file(.clock(clock),.reset(reset),.reg_write_En(reg_Write),.reg_write_Dest(reg_write_Dest),.reg_write_Data(reg_write_Data),.reg_read_Addr_1(reg_read_Addr_1),.reg_read_Data_1(reg_read_Data_1),.reg_read_Addr_2(reg_read_Addr_2),.reg_read_Data_2(reg_read_Data_2),.LED_state(LEDs_out));

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  //ALU CONTROL
  
  wire [2:0] ALU_Control;
  
  //instruct[5:0] goes into ALU control unit.
  
  alu_control alu_control(.aluop(aluop),.Function(instruct[5:0]),.ALU_Control(ALU_Control));

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  //ALU
  
  wire [31:0] read_Data2;
  wire [31:0] alu_out;
  wire zero_flag;
  
  //Multiplexer for second ALU input
  assign read_Data2 =  (alu_Source) ? sign_ext_Imm : reg_read_Data_2;
  
  //Equivalent to:
  /*
  if(alu_Source == 1)
  {
    read_Data2 = sign_ext_Imm;
  }
  else
  {
    read_Data2 = reg_read_Data_2;
  }
  */
  
  
  //Alu 
  //The ALU unit takes in the result of the Multiplexer above and the reg_read_Data_1 value from the Register File. It outputs a "zero flag" and the result.
  
  alu alu(.firstValue(reg_read_Data_1),.secondValue(read_Data2),.alu_control(ALU_Control),.result(alu_out),.zero_flag(zero_flag));
  
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  //DATA MEMORY
  
  wire [31:0] mem_write_Data;
  wire [31:0] mem_access_Addr;
  wire [31:0] mem_read_Data;
  
  //Write 
  assign reg_write_Data = (memtoReg == 2'b0) ? alu_out : mem_read_Data;
  
  data_memory data_memory(.clock(clock),.mem_access_Addr(alu_out),.mem_write_Data(reg_read_Data_2),.mem_write_En(mem_Write),.mem_Read(mem_Read),.mem_read_Data(mem_read_Data));
  
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
 //Program Counter
  
  always @(posedge clock or posedge reset)
   begin
     		if(reset | pc_Current == 32'd12)
            begin 
              		pc_Current <= 31'd0;
            end 
     		else if(SWITCH_in)
              begin
                pc_Current <= pc_Current;
              end
     		else 
            begin
              		pc_Current <= pc_Next;
            end 
   end 
  

endmodule 