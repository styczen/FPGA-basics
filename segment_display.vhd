library IEEE ;
use IEEE . STD_LOGIC_1164 . ALL ;
use IEEE . STD_LOGIC_UNSIGNED . ALL ;
entity main is
Port ( CLK100MHZ : in STD_LOGIC ;
       AN : out STD_LOGIC_VECTOR (7 downto 0) ;
       SEG : out STD_LOGIC_VECTOR (6 downto 0)
) ;
end main ;

architecture Behavioral of main is
  -- przypisanie odpowiednich kombinacji zapalen segmentow dla cyfr od 0 do 9
  constant segment0 : STD_LOGIC_VECTOR (6 downto 0) := " 1000000 " ;
  constant segment1 : STD_LOGIC_VECTOR (6 downto 0) := " 1111001 " ;
  constant segment2 : STD_LOGIC_VECTOR (6 downto 0) := " 0100100 " ;
  constant segment3 : STD_LOGIC_VECTOR (6 downto 0) := " 0110000 " ;
  constant segment4 : STD_LOGIC_VECTOR (6 downto 0) := " 0011001 " ;
  constant segment5 : STD_LOGIC_VECTOR (6 downto 0) := " 0010010 " ;
  constant segment6 : STD_LOGIC_VECTOR (6 downto 0) := " 0000011 " ;
  constant segment7 : STD_LOGIC_VECTOR (6 downto 0) := " 1111000 " ;
  constant segment8 : STD_LOGIC_VECTOR (6 downto 0) := " 0000000 " ;
  constant segment9 : STD_LOGIC_VECTOR (6 downto 0) := " 0011000 " ;
  constant segmentN : STD_LOGIC_VECTOR (6 downto 0) := " 1111111 " ; -- wszystkie segmenty zgaszone

  -- procedura przekodowania cyfry wejsciowej na
  procedure BCD2seg ( constant in1 : in integer ;
                      variable out1 : out STD_LOGIC_VECTOR (6 downto 0) ) is
    variable var_out : STD_LOGIC_VECTOR (6 downto 0) ;
    begin
    case in1 is --w zaleznoci od cyfry wejsciowej ustaw odpowiednie segmenty
      when 0 = > var_out := segment0 ;
      when 1 = > var_out := segment1 ;
      when 2 = > var_out := segment2 ;
      when 3 = > var_out := segment3 ;
      when 4 = > var_out := segment4 ;
      when 5 = > var_out := segment5 ;
      when 6 = > var_out := segment6 ;
      when 7 = > var_out := segment7 ;
      when 8 = > var_out := segment8 ;
      when 9 = > var_out := segment9 ;
      when others = > var_out := segmentN ; -- wszystkie segmenty zgaszone
    end case ;
    out1 := var_out ; -- przepisz zmienna tymczasowa do wyjsciowej
  end BCD2seg ;

  procedure number2dig ( constant number : in integer := 0;
                         variable out1 : out integer ;
                         variable out2 : out integer ;
                         variable out3 : out integer ;
                         variable out4 : out integer ) is

  variable temp1 : integer ;
  variable temp2 : integer ;
  variable temp3 : integer ;
  variable temp4 : integer ;
  begin
    -- obliczanie wartosci cyfry tysiecy
    temp4 := ( number / 1000) ;
    out4 := temp4 ;
    if temp4 = 0 then
      if number < 1000 then
        out4 := -1;
      end if ;
    end if ;
    -- obliczanie wartosci cyfry setek
    temp3 := (( number - temp4 * 1000) / 100) ;
    out3 := temp3 ;
    if temp3 = 0 then
      if number < 100 then
        out3 := -1;
      end if ;
    end if ;
    -- obliczanie wartosci cyfry dziesiatek
    temp2 := (( number - temp4 * 1000 - temp3 * 100) / 10) ;
    out2 := temp2 ;
    if temp2 = 0 then
      if number < 10 then
        out2 := -1;
      end if ;
    end if ;
    -- obliczanie wartosci cyfry jednosci
    temp1 := ( number - temp4 * 1000 - temp3 * 100 - temp2 * 10) ;
    out1 := temp1 ;
  end number2dig;

  process ( CLK100MHZ )
  variable cnt : integer := 0;
  variable cnt1 : integer := 0;
  variable number : integer := 0;
  variable var_an : STD_LOGIC_VECTOR (3 downto 0) := " 1110 " ;
  variable var_seg : STD_LOGIC_VECTOR (6 downto 0) := " 1111111 " ;
  -- zmienne reprezentujace 4 cyfry na wyswietlaczach
  variable dig1 : integer := 0;
  variable dig2 : integer := 0;
  variable dig3 : integer := 0;
  variable dig4 : integer := 0;
  begin
    if rising_edge ( CLK100MHZ ) then
      cnt := cnt + 1; -- licznik do multipleksowania 4 wyswietlaczy (200 Hz )
      cnt1 := cnt1 + 1; -- licznik do inkrementacji liczby (10 Hz )
      if cnt1 = 10000000 then
        cnt1 := 0;
        number := number + 1;
          if number = 10000 then
            number := 0;
          end if ;
      end if ;
      if cnt = 500000 then
        cnt := 0;
        number2dig ( number , dig1 , dig2 , dig3 , dig4 ) ;
        case var_an is
          when " 0111 " = > var_an := " 1110 " ; BCD2seg ( dig1 , var_seg ) ;
          when " 1110 " = > var_an := " 1101 " ; BCD2seg ( dig2 , var_seg ) ;
          when " 1101 " = > var_an := " 1011 " ; BCD2seg ( dig3 , var_seg ) ;
          when " 1011 " = > var_an := " 0111 " ; BCD2seg ( dig4 , var_seg ) ;
          when others = > var_an := " 1111 " ; var_seg := " 1111111 " ; --wszystkie wyswietlacze zgaszone
        end case ;
      end if ;
      -- przypisanie , ktory wyswietlacz i jakie segmenty maja byc zapalone
      AN <= var_an ;
      SEG <= var_seg ;
    end if ;
  end process ;
end Behavioral ;
