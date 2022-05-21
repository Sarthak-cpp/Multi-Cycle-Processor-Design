library IEEE;
use IEEE.std_logic_1164.all; -- standard libraries
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;
use work.MyTypes.all;
entity DR is --The register DR as defined on page 30 of Lec10
	PORT(
        DW: IN STD_LOGIC;
        rd: in word;
        DR_out: OUT word
        );
end DR;

Architecture drdr of DR is
begin
Process(DW,rd)
begin
IF(DW = '1') THEN --Output the value when select bit is 1
	DR_out<=rd;
Else null;
end if;
end process;
end drdr;