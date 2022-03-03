----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2022 04:47:27 PM
-- Design Name: 
-- Module Name: counterBCD - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counterBCD is
    Port ( ck100MHz : in STD_LOGIC;
           resCnt : in STD_LOGIC;
           enCnt : in STD_LOGIC;
           data : out unsigned (15 downto 0));
end counterBCD;

architecture Behavioral of counterBCD is

    signal cntBCD: unsigned (15 downto 0);
    constant cstPresc: integer :=1000000;
    signal cntPresc: integer range 0 to cstPresc-1;
    signal ck100Hz: std_logic;

begin

--    counter: process(ck100MHz, resCnt) 
--    begin
--        if (resCnt='1') then
--            cntBCD<=(others=>'0');
--        elsif (rising_edge(ck100MHz)) then
--            if (enCnt='1') then
--                cntBCD<=cntBCD+1;
--            end if;
--        end if;
--    end process;

    data<=cntBcd;
    
    prescaller: process(ck100MHz, resCnt)
    begin
        if resCnt = '1' then  -- asynchronous reset
      cntPresc <= 0;
    elsif rising_edge(ck100MHz) then
      if enCnt = '1' then -- synchronous enable
        if cntPresc = cstPresc - 1 then
          cntPresc <= 0;
          ck100Hz <= '1';  -- see alternatives
        else
          cntPresc <= cntPresc + 1;
          ck100Hz <= '0'; -- see alternatives
        end if;
      end if;    
    end if;
  end process;
  
    BcdCounter: process(ck100Hz, resCnt)
      begin
        if resCnt = '1' then
          cntBcd <= (others => '0');
        elsif rising_edge(ck100Hz) then data<=cntBcd;
          if enCnt = '1' then
            if cntBcd(3 downto 0) = "1001" then  -- if digit is 9Behavioral;
              cntBcd(3 downto 0) <= "0000";  -- set digit to 0 
              if cntBcd(7 downto 4) = "1001" then  -- analyze next digit 
                cntBcd(7 downto 4) <= "0000"; -- unsigned immediate value (by context) 
                if cntBcd(11 downto 8) = x"9" then  -- hexadecimal immediate value
                  cntBcd(11 downto 8) <= x"0";
                  if cntBcd(15 downto 12) = "1001" then -- if digit is 9
                    cntBcd(15 downto 12) <= "0000"; -- set digit to 0 (no "next digit")
                  else                                                  -- digit is not 9
                    cntBcd(15 downto 12) <= cntBcd(15 downto 12) + 1; -- increment digit
                  end if; 
                else
                    cntBcd(11 downto 8) <= cntBcd(11 downto 8) + 1;  -- implicit type conversion
                     end if;      
                else
                            cntBcd(7 downto 4) <= cntBcd(7 downto 4) + 1;  -- to_unsigned (integer, size) 
                          end if;      
                        else
                          cntBcd(3 downto 0) <= cntBcd(3 downto 0) + 1;
                        end if;      
                      end if;
                    end if;
                  end process;    
end Behavioral;