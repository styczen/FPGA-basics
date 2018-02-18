library IEEE ;
use IEEE . STD_LOGIC_1164 . ALL ;
entity MyFirst is
Port ( SW : inout STD_LOGIC_VECTOR (15 downto 0) ;
      LED : out STD_LOGIC_VECTOR (6 downto 0) ) ;
end MyFirst ;

architecture Behavioral of MyFirst is
  -- deklaracja sygnalu znajduje sie w bloku architecture prze beginem
  signal TMP : STD_LOGIC_VECTOR (6 downto 0) ;
  begin
    TMP (0) <= SW (0) and SW (1) when SW (15) = ’1 ’ else ’0 ’;
    TMP (1) <= SW (0) nand SW (1) when SW (15) = ’1 ’ else ’0 ’;
    TMP (2) <= SW (0) or SW (1) when SW (15) = ’1 ’ else ’0 ’;
    TMP (3) <= SW (0) nor SW (1) when SW (15) = ’1 ’ else ’0 ’;
    TMP (4) <= SW (0) xor SW (1) when SW (15) = ’1 ’ else ’0 ’;
    TMP (5) <= SW (0) xnor SW (1) when SW (15) = ’1 ’ else ’0 ’;
    TMP (6) <= not SW (0) when SW (15) = ’1 ’ else ’0 ’;
    LED <= TMP ; -- przepisanie stanu sygnalu tymczasowego do sygnalu wyjsciowego ;
    nalezy pamietac aby w czesci rownoleglej nie zmieniac stanu tego samego
    sygnalu kilkukrotnie , bo na wyjsciu otrzymamy stan pierwszego
    przypisania
end Behavioral ;
