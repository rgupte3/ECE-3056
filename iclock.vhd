--
-- Name - Ria Gupte
-- GT Id - 902758920  rgupte3
-- No changes were made to this module
--

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity my_clock is
port ( signal sys_clock, reset : out std_logic);
end entity my_clock;

architecture behavior of my_clock is 
begin
    process
        begin
        -- generate clock
          sys_clock <= '0', '1' after 50 ns;
          wait for 100 ns;
         end process; 
         -- following statement executes only once
reset <= '1', '0' after 75 ns;
end architecture behavior;
    
