-- ECE 3055 Computer Architecture and Operating Systems
--
-- MIPS Processor VHDL Behavioral Model
--
-- Ifetch module (provides the PC and instruction memory) 
-- 
-- School of Electrical & Computer Engineering
-- Georgia Institute of Technology
-- Atlanta, GA 30332
--
-- Name - Ria Gupte
-- GT Id - 902758920  rgupte3
-- Changes in this module: Added the test program code and changed the length of the INST_MEM array 
-- to accomodate for the number of instructions
--
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Ifetch IS
	PORT(	SIGNAL Instruction 		: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	SIGNAL PC_plus_4_out 	: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        	SIGNAL Add_result 		: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
        	SIGNAL Branch 			: IN 	STD_LOGIC;
        	SIGNAL Zero 			: IN 	STD_LOGIC;
      		SIGNAL PC_out 			: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        	SIGNAL clock, reset 	: IN 	STD_LOGIC);
END Ifetch;

ARCHITECTURE behavior OF Ifetch IS
   TYPE INST_MEM IS ARRAY (0 to 10) of STD_LOGIC_VECTOR (31 DOWNTO 0);
   SIGNAL iram : INST_MEM := (

	-- Code for the test program
 	X"8CA30000", -- lw $3, 0($5)             
 	X"00431020", -- add $2, $2, $3  , sum = $2      
 	X"00A82820", -- add $5, $5, $8 , increment by 4 the offset          
 	X"00E93820", -- add $7, $7, $9 , subtract 1 to decrease the size
 	X"00E0302A", -- slt $6, $7, $0           
 	X"10C0FFFA", -- beq $6, $0, -6*4 
 	X"A8820000", -- swa $2, 0($4)
	X"A8820000", -- swa $2, 0($4)
	--X"AC040000", -- sw $3, 0($0)
	-- End of test program

       X"1022FFFF",   -- beq $1,$2,-4  
       X"1021FFFA"    -- beq $1,$1,-24 (Assume delay slot present, so it  
                     -- New PC = PC+4-24 = PC-20
   );
    
	SIGNAL PC, PC_plus_4 	 : STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL Mem_Addr		 : STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL next_PC		 : STD_LOGIC_VECTOR( 7 DOWNTO 0 );
BEGIN 						
					
		PC(1 DOWNTO 0) <= "00";
					-- copy output signals - allows read inside module
		PC_out 			<= PC;
		PC_plus_4_out 	<= PC_plus_4;
						-- send address to inst. memory address register
		Mem_Addr <= Next_PC;
						-- Adder to increment PC by 4        
      	PC_plus_4( 9 DOWNTO 2 )  <= PC( 9 DOWNTO 2 ) + 1;
      	PC_plus_4( 1 DOWNTO 0 )  <= "00";
						
                  	-- Mux to select Branch Address or PC + 4     
		Next_PC  <= Add_result WHEN ( (Branch='1') AND ( Zero='1' ) ) ELSE
            X"00" WHEN Reset = '1' ELSE
			   PC_plus_4( 9 DOWNTO 2 );

	PROCESS
		BEGIN
			WAIT UNTIL ( clock'EVENT ) AND ( clock = '1' );
			IF reset = '1' THEN
				   PC( 9 DOWNTO 2) <= "00000000" ;
			ELSE 
				   PC( 9 DOWNTO 2 ) <= next_PC;
			END IF;
			Instruction <= iram(CONV_INTEGER(Mem_Addr));
	END PROCESS;
END behavior;


