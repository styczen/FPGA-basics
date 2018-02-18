library IEEE ;
use IEEE . STD_LOGIC_1164 . ALL ;
use IEEE . STD_LOGIC_unsigned . ALL ;

entity main is
  Port ( CLK100MHZ : in STD_LOGIC ;
         LED : out STD_LOGIC ;
         SW : in STD_LOGIC_VECTOR (7 downto 0)
  ) ;
end main ;

architecture Behavioral of main is
signal CNT : STD_LOGIC_VECTOR (7 downto 0) ; -- licznik do PWM , rozdzielczosc PWM to 256
begin
  PWM : process ( CLK100MHZ )
  variable CNT_50HZ : integer := 0; -- licznik , aby uzyskac czestoliwosc migania LED 50 Hz
  begin
    if rising_edge ( CLK100MHZ ) then
      if ( CNT_50HZ = 2000000) then -- 2000000 = 100 MHz \ 50 Hz , aby uniknac delikatnego migotania diody
        CNT_50HZ := 0;
        CNT <= CNT + 1;
        if ( CNT < SW ) then -- sprawdz jaki jest aktualny stan wypelnienia, aby w odpowiednim momencie zgasic diode
          LED <= ’1 ’;
        else
          LED <= ’0 ’;
        end if ;
      else
        CNT_50HZ := CNT_50HZ + 1;
      end if ;
    end if ;
  end process ;
end Behavioral ;
