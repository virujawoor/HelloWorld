----------------------------------------------------------------------------------
-- Company		: 	CEM SOLUTIONS
-- Engineer		: 	Viru Jawoor	
-- 
-- Create Date	:   09:18:01 06/01/2015 
-- Design Name	: 
-- Module Name	:   Goertzel_Filter_Impadence - Behavioral 
-- Project Name	: 
-- Target Devices: 
-- Tool versions: 
-- Description	: 
--
-- Dependencies	: 
--
-- Revision		: 
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

entity Goertzel_Filter_Impadence is
port (	 wb_clk  		: in  std_logic;      
		 wb_rst    		: in  std_logic;
		 Fsync    		: in  std_logic;
		 filter_in		: in  std_logic_vector (15 downto 0);
		 filter_out		: out std_logic_vector (15 downto 0);
		 decode_en 		: out std_logic);
end Goertzel_Filter_Impadence;		 
		 
architecture Behavioral of Goertzel_Filter_Impadence is 
		 
component Goertzel_Controller
    Port ( clk 						: in  STD_LOGIC;
           Fsync 					: in  STD_LOGIC;
           wb_rst 					: in  STD_LOGIC;
           q_rst 					: out STD_LOGIC;
           o_en 					: out STD_LOGIC;
           midmul_en 				: out STD_LOGIC;		   
           postmul_en 				: out STD_LOGIC;		   
           decode_en 				: out STD_LOGIC);		   
end component;		 

	component post_processing
	port(
		wb_clk 	: IN std_logic;
		wb_rst 		: IN std_logic;
		clk_ce		: IN std_logic;
		stm2mult_en	: IN std_logic;		
		Q1 			: IN std_logic_vector(15 downto 0);
		Q2 			: IN std_logic_vector(15 downto 0);
		mid 		: IN std_logic_vector(15 downto 0);
		geortzel_out: OUT std_logic_vector(15 downto 0)
		);
	
	end component;
		 
component Goertzel_Filter 
generic(coeff 			:  std_logic_vector(15 downto 0));  
  port( clk_gate      	: in std_logic;
        wb_clk    		: in std_logic;
        clk_enable    	: in std_logic;
        reset         	: in std_logic;
		q_rst         	: in std_logic;
		mid_mul_en    	: in std_logic;
        filter_in     	: in std_logic_vector(15 downto 0);        
		Q1_out    		: out std_logic_vector(15 downto 0);
		Q2_out    		: out std_logic_vector(15 downto 0);
		mid_out    		: out std_logic_vector(15 downto 0));
end component;		 


signal Q1 	: std_logic_vector(15 downto 0) ;		 
signal Q2 	: std_logic_vector(15 downto 0) ;		 
signal mid	: std_logic_vector(15 downto 0) ;
signal o_en				: std_logic;		 
signal q_rst			: std_logic;		 
signal midmul_en		: std_logic;		 
signal postmul_en		: std_logic;		 
		 
begin		 
CTRL : Goertzel_Controller 
    Port Map (
		clk 			 => wb_clk,
        Fsync 			 => Fsync,
        wb_rst 			 => wb_rst,
        q_rst 			 => q_rst,
        o_en 			 => o_en,
        midmul_en 		 => midmul_en,
        postmul_en 		 => postmul_en,
        decode_en 		 => decode_en);
		

FILTER: Goertzel_Filter
   generic map(coeff=>x"68B3") --770
   port map (   
        clk_gate	=> Fsync,
		wb_clk   	=> wb_clk,				
		clk_enable	=> '1',				
		reset		=> wb_rst,
		q_rst		=> q_rst,				
		mid_mul_en	=> midmul_en,				
		filter_in   => filter_in,
		Q1_out  	=> Q1,
		Q2_out 		=> Q2, 		
		mid_out 	=> mid); 		
		
Inst_post_processing: post_processing --** mag = (Q1^2  + Q2^2 - mid*Q2)
		PORT MAP(
		wb_clk 		=> wb_clk,
		wb_rst 		=> wb_rst,
		clk_ce		=> q_rst,			--'1',--
		stm2mult_en	=> postmul_en,
		Q1 			=> Q1,
		Q2 			=> Q2,
		mid 		=> mid,
		geortzel_out=> filter_out);	
end behavioral;		
		