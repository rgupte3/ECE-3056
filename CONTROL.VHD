-- ECE 3055 Computer Architecture and Operating Systems
--
-- MIPS Processor VHDL Behavioral Model
--		
-- control module (implements MIPS control unit)
--
-- School of Electrical & Computer Engineering
-- Georgia Institute of Technology
-- Atlanta, GA 30332
-- 
--
-- Name - Ria Gupte
-- GT Id - 902758920  rgupte3
-- Changes in this module: the control signals were initialised according to the functionality of swa.
-- ALUSrc=1, RegWrite =1, MemWrite=1 and AddFour =1
-- also the opcode of swa is 101010 so Swa was initialised to 1 when that opcode is fetched
--
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY control IS
   PORT( 	
	SIGNAL Opcode 		: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	SIGNAL RegDst 		: OUT 	STD_LOGIC;
	SIGNAL ALUSrc 		: OUT 	STD_LOGIC;
	SIGNAL MemtoReg 	: OUT 	STD_LOGIC;
	SIGNAL RegWrite 	: OUT 	STD_LOGIC;
	SIGNAL MemRead 		: OUT 	STD_LOGIC;
	SIGNAL MemWrite 	: OUT 	STD_LOGIC;
	SIGNAL Branch 		: OUT 	STD_LOGIC;
	SIGNAL ALUop 		: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	SIGNAL AddFour		: OUT   STD_LOGIC;
	SIGNAL clock, reset	: IN 	STD_LOGIC );

END control;

ARCHITECTURE behavior OF control IS

	SIGNAL  R_format, Lw, Sw, Swa, Beq 	: STD_LOGIC;

BEGIN           
				-- Code to generate control signals using opcode bits
	R_format 	<=  '1'  WHEN  Opcode = "000000"  ELSE '0';
	Lw          <=  '1'  WHEN  Opcode = "100011"  ELSE '0';
 	Sw          <=  '1'  WHEN  Opcode = "101011"  ELSE '0';
	Swa	    <=  '1'  WHEN  Opcode = "101010"  ELSE '0';
   	Beq         <=  '1'  WHEN  Opcode = "000100"  ELSE '0';
  	RegDst    	<=  R_format;
 	ALUSrc  	<=  Lw OR Sw OR Swa;
	MemtoReg 	<=  Lw;
  	RegWrite 	<=  R_format OR Lw OR Swa;
  	MemRead 	<=  Lw;
   	MemWrite 	<=  Sw OR Swa; 
	AddFour 	<=  Swa;
 	Branch          <=  Beq;
	ALUOp( 1 ) 	<=  R_format;
	ALUOp( 0 ) 	<=  Beq; 

   END behavior;


