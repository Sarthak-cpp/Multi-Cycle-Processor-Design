library IEEE;
use IEEE.std_logic_1164.all; -- standard libraries
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;
use work.MyTypes.all;

-- Register Design
Entity RegisterFiles IS
	PORT(
    	rad1:in nibble;
        rad2:in nibble;
        wad:in nibble;
        Clk: IN STD_LOGIC;
        RW: IN STD_LOGIC;
        wd: IN word;
        Rd1: OUT word;
        Rd2: OUT word
        );
END RegisterFiles;

-- Register Architecture
ARCHITECTURE BEV OF RegisterFiles IS

TYPE RegArray IS ARRAY (15 DOWNTO 0) OF word;
SIGNAL Reg : RegArray;
SIGNAL ADDR1 : INTEGER RANGE 0 TO 15;
SIGNAL ADDR2 : INTEGER RANGE 0 TO 15;
SIGNAL ADDR3 : INTEGER RANGE 0 TO 15;

Begin
	ADDR1<=CONV_INTEGER(rad1);
    ADDR2<=CONV_INTEGER(rad2);
    ADDR3<=CONV_INTEGER(wad);
    Rd1<=Reg(CONV_INTEGER(rad1));
    Rd2<=Reg(CONV_INTEGER(rad2));
	Process(Clk,rad1,rad2,wad,RW,wd)
    Begin    
    IF(rising_edge(Clk))THEN
    	IF(RW = '1')THEN
        	Reg(ADDR3)<=wd;
        end if;
    end if;
  End Process;
End BEV;