----------------------------------------------------------------------------------
-- Company: 	CEM SOLUTIONS
-- Engineer: 	Viru Jawoor
-- 
-- Create Date:    14:40:44 06/08/2009 
-- Design Name: 
-- Module Name:    Goertzel_timing - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Goertzel_timing is
    Port ( clk 		: in  STD_LOGIC;
           wb_rst 		: in  STD_LOGIC;
           q_rst 	: out STD_LOGIC;
           o_en 	: out STD_LOGIC);
end Goertzel_timing;

architecture Behavioral of Goertzel_timing is
signal N : std_logic_vector(7 downto 0) := (others=>'0');
signal cnt_rst : std_logic := '0';
begin
 
  process(clk,wb_rst,cnt_rst)
   begin
     if wb_rst = '1' then
       N <=  "00000000";
     elsif clk'event and clk = '1' then
       if (cnt_rst = '0') then 
         N <= N + 1;
       else
         N <= "00000001";
       end if;
     end if; 
   end process;
	
  process(clk,wb_rst)
   begin
     if wb_rst = '1' then
       cnt_rst <=  '1';      
     elsif clk'event and clk = '1' then
       if (N = "11001100") then --204/205     --  ---01101001
         cnt_rst <= '1';        
       else
         cnt_rst <= '0';
       end if;
     end if; 
   end process;	
	
q_rst <= '1' when (N = "11001101") else '0';
o_en <= '1' when (N = "00000001") else '0';

end Behavioral;

