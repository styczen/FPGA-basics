library IEEE ;
use IEEE . STD_LOGIC_1164 . ALL ;
entity main is
Port ( CLK100MHZ : in STD_LOGIC ;
       LED : out STD_LOGIC_VECTOR (15 downto 0) ) ;
end main ;

architecture Behavioral of main is
begin
  process ( CLK100MHZ ) -- calosc kodu w czesci synchronicznej
  variable CNT : integer ;
  begin
    if rising_edge ( CLK100MHZ ) then
      CNT := CNT + 1;
      if CNT < 7142857 then -- rowne 14285714 / 2
        LED (0) <= ’1 ’;
      elsif CNT < 14285714 then -- dla czestotliwosci 7 Hz , 100 MHz / 7 Hz = okolo 14285714
        LED (0) <= ’0 ’;
      elseif CNT = 14285714 then
        CNT := 0;
      end if ;
    end if ;
  end process ;
end Behavioral ;
