library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; 
use ieee.std_logic_arith.all;


entity filter_770 is
 port( clk_gate           : in std_logic;
       clk_enable    : in std_logic;
       reset         : in std_logic;
       filter_in     : in std_logic_vector(15 downto 0);
       filter_out    : out std_logic_vector(15 downto 0);
       test1         : out std_logic_vector(31 downto 0);
       test_delay1   : out std_logic_vector(15 downto 0);
       test_f        : out std_logic_vector(16 downto 0)
      -- test_f2       : out std_logic_vector(15 downto 0)
    );
end filter_770;

architecture filter_a of filter_770 is 

constant coeff1 : std_logic_vector(15 downto 0) := "0110100010110010"; --"0110110100000010";--"0000000000000000"; --"0110110100000010";--1.7033//--"0110110001000011//1.6916" ;  --coeff = 1.6916, normalized frequency = 697hz

signal product1 : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";  
signal product2 : std_logic_vector(31 downto 0) := "00000000000000000000000000000000"; 
--signal product3 : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal product4 : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";   

signal product111 : std_logic_vector(15 downto 0) := "0000000000000000";  
signal product222 : std_logic_vector(15 downto 0) := "0000000000000000"; 
--signal product333 : std_logic_vector(15 downto 0) := "0000000000000000";
signal product444 : std_logic_vector(15 downto 0) := "0000000000000000";

 
signal final_product : std_logic_vector(16 downto 0) := "00000000000000000" ;
signal final_product222 : std_logic_vector(16 downto 0) := "00000000000000000" ;

signal delay_pipeline : std_logic_vector(15 downto 0):= "0000000000000000";
signal delay_pipeline2 : std_logic_vector(15 downto 0):= "0000000000000000";

signal delay_fil : std_logic_vector(16 downto 0) := "00000000000000000";
signal delay_fil22 : std_logic_vector(16 downto 0) := "00000000000000000";
signal N : std_logic_vector(7 downto 0) := "00000001";
signal mid : std_logic_vector(31 downto 0):= "00000000000000000000000000000000";
signal mid22 : std_logic_vector(15 downto 0):= "0000000000000000";
signal count : std_logic_vector(1 downto 0) := "00";
signal count_rst : std_logic := '0';
signal cnt_rst : std_logic := '0';
signal cnt_en : std_logic := '0';
signal flag_clk : std_logic := '0';
--signal clk_gate : std_logic := '0'; 
signal flag : std_logic := '0';
signal flag1 : std_logic := '0';
signal flag2 : std_logic := '0';
signal flag3 : std_logic := '0';
signal flag4 : std_logic := '0';

begin

mid <= conv_std_logic_vector(signed(coeff1)*signed(delay_pipeline),32);
mid22 <= mid(29 downto 14);
delay_fil <= conv_std_logic_vector(signed(filter_in) + signed(mid22),17);
delay_fil22 <= conv_std_logic_vector(signed(delay_fil) - signed(delay_pipeline2),17); 
  
--  process(clk,reset,clk_enable)
--     begin
--      if reset = '1' then
--        flag_clk <= '0';
--      elsif clk'event and clk = '1' then
--         if clk_enable = '1' then   
--           flag_clk <= '1';
--         else
--           flag_clk <= '0';
--         end if;
--      end if;   
--  end process; 
--  
--  clk_gate <= clk and flag_clk;        
             
  process(clk_gate,reset,clk_enable,N)
    begin
      if reset = '1' then
         delay_pipeline <= "0000000000000000";
         delay_pipeline2 <= "0000000000000000";
      elsif clk_gate'event and clk_gate = '1' then
         if (clk_enable = '1') then
                   
              if(N = "11001101") then 
               delay_pipeline <= "0000000000000000";
               delay_pipeline2 <= "0000000000000000";
              else                
               delay_pipeline2 <= delay_pipeline;       
               delay_pipeline <= delay_fil22(16 downto 1);
              end if;
          
         end if;
      end if;
  end process;
  
  --process(clk_gate,reset)
--   begin
--     if reset = '1' then
--       flag <= '0';
--     elsif clk_gate'event and clk_gate = '1' then
--       if (clk_enable = '1') then
--         flag <= '1';
--       else
--         flag <= '0';
--       end if;
--     end if;
--  end process;    
--  
   -- process(clk_gate,reset)
--   begin
--     if reset = '1' then
--       flag1 <= '0';
--     elsif clk_gate'event and clk_gate = '1' then
--       if (clk_enable = '1' and flag = '1') then
--         flag1 <= '1';
--       else
--         flag1 <= '0';
--       end if;
--     end if;
--  end process; 
--  
--    process(clk_gate,reset)
--   begin
--     if reset = '1' then
--       flag2 <= '0';
--     elsif clk_gate'event and clk_gate = '1' then
--       if (clk_enable = '1' and flag1 = '1') then
--         flag2 <= '1';
--       else
--         flag2 <= '0';
--       end if;
--     end if;
--  end process;  
  --
--    process(clk_gate,reset)
--   begin
--     if reset = '1' then
--       flag3 <= '0';
--     elsif clk_gate'event and clk_gate = '1' then
--       if (clk_enable = '1' and flag2 = '1' ) then
--         flag3 <= '1';
--       else
--         flag3 <= '0';
--       end if;
--     end if;
--  end process;  
--  
--      process(clk_gate,reset)
--   begin
--     if reset = '1' then
--       flag4 <= '0';
--     elsif clk_gate'event and clk_gate = '1' then
--       if (clk_enable = '1' and flag3 = '1' ) then
  --       flag4 <= '1';
--       else
--         flag4 <= '0';
--       end if;
--     end if;
--  end process;             

  process(clk_gate,reset,cnt_rst)
   begin
     if reset = '1' then
       N <=  "00000001";
     elsif clk_gate'event and clk_gate = '1' then
       if (clk_enable = '1' and cnt_rst = '0') then -- and flag4 = '1' and cnt_rst = '0') then
         N <= N + 1;
       else
         N <= "00000001";
       end if;
     end if; 
   end process;
   
   
 --  process(clk_gate,reset,cnt_en)
--   begin
--     if reset = '1' then
--       count <=  "00";
--     elsif clk_gate'event and clk_gate = '1' then
--       if (clk_enable = '1' and cnt_en = '1') then
--         count <= count + 1;
--       else
--         count <= "00";
--       end if;
--     end if; 
--   end process;    
   
   process(clk_gate,reset)
   begin
     if reset = '1' then
       cnt_rst <=  '1';
      
     elsif clk_gate'event and clk_gate = '1' then
       if (N = "11001100") then --204/205
         --flag <= '0';
--         flag1 <= '0';
--         flag2 <= '0';
--         flag3 <= '0';
         cnt_rst <= '1';
        
       else
         cnt_rst <= '0';
       end if;
     end if; 
   end process;
   
--  process(clk_gate,reset)
--   begin
--     if reset = '1' then
--       cnt_en <=  '0';
--     elsif clk_gate'event and clk_gate = '1' then
--       if (N = "11001101") then  --204//205
--           cnt_en <= '1';
--       end if;   
--       if (count = "10") then
--         cnt_en <= '0';
--       end if;
--     end if; 
--   end process; 
   
       
       
  
  process(clk_gate,reset)
   begin
     if reset = '1' then
       product1 <= "00000000000000000000000000000000";
       product2 <= "00000000000000000000000000000000";
       product4 <= "00000000000000000000000000000000";
     elsif clk_gate'event and clk_gate = '1' then
       if (clk_enable = '1') then
        -- if(N = "11001110") then  -- --205//206 
             product1 <= conv_std_logic_vector(signed(delay_pipeline2) * signed(delay_pipeline2),32);
          
             product2 <= conv_std_logic_vector(signed(delay_pipeline) * signed(delay_pipeline),32);
           
             product4 <= conv_std_logic_vector(signed(mid22) * signed(delay_pipeline2),32);
                                         
           
        -- end if;   
       end if;
     end if;        
   end process;
   
   process(clk_gate,reset)
    begin
     if reset = '1' then
       filter_out <=  "0000000000000000";
     elsif clk_gate'event and clk_gate = '1' then
       if (clk_enable = '1') then     
        -- if(count = "01") then
           final_product <= conv_std_logic_vector(signed(product1(29 downto 14)) + signed(product2(29 downto 14)),17);
           final_product222 <= conv_std_logic_vector(signed(final_product) - signed(product4(29 downto 14)),17);
           if(N = "11001011") then
         
            filter_out <= final_product222(16 downto 1);
           else
            filter_out <= "0000000000000000";  
           end if;    
                     
        
       end if;
     end if;
   end process;
   
   

  test1 <= mid;   
  test_delay1 <= mid22;
  test_f <= final_product; 
  --test_f2 <= final_product222;

end filter_a; 
