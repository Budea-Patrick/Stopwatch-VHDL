----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2022 07:52:29 PM
-- Design Name: 
-- Module Name: TopCrono - Behavioral
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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TopCrono is
    Port ( ck100MHz : in STD_LOGIC;
           btnC : in STD_LOGIC; -- reset 
           sw :  in STD_LOGIC_VECTOR (0 downto 0);  -- enable
           led :  out unsigned (15 downto 0);  -- binary display on LEDs
           seg : out STD_LOGIC_VECTOR (6 downto 0);  -- 7 segment display: segments
           an : out STD_LOGIC_VECTOR (3 downto 0); -- 7 segment display: anodes
           dp : out std_logic); -- 7 segment display: decimal point
 
end TopCrono;


architecture Structural of TopCrono is

    signal data : unsigned (15 downto 0);
    signal enCnt, resCnt: std_logic;
    signal btnCDeb: std_logic; -- debounced btnC
    
    component ctrl7seg is
  Port (
    ck100MHz : in STD_LOGIC;
    data : in unsigned(15 downto 0);
    seg : out STD_LOGIC_VECTOR (6 downto 0);
    an : out STD_LOGIC_VECTOR (3 downto 0);
    dp : out std_logic);
end component;

component counterBcd is
  Port ( 
    ck100MHz : in STD_LOGIC;
    resCnt : in STD_LOGIC;  -- reset
    enCnt : in STD_LOGIC;  -- enable
    data : out unsigned(15 downto 0));
end component;


begin
    
    instctrl7seg: ctrl7seg 
    Port map(
      ck100MHz => ck100MHz,
      data => data,
      seg => seg,
      an => an,
      dp => dp);


instBcd: counterBcd 
    Port map (    
         ck100MHz => ck100MHz,
         resCnt => resCnt,  -- reset      
         enCnt => enCnt,  -- enable      
         data => data);

    led<=data;
    enCnt<=sw(0);
    resCnt<=btnC;

end Structural;
