library IEEE;
use IEEE.std_logic_1164.all; -- standard libraries
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;
use work.MyTypes.all;
--The register A defined on page 30 of lecture 6
entity A is
	PORT(
        AW: IN STD_LOGIC;
        rd1: in word;
        A_out: OUT word
        );
end A;

Architecture aaaa of A is
begin
Process(AW,rd1)
begin
IF(AW = '1') THEN --Output the value when the select bit is 1
	A_out<=rd1;
Else null;
end if;
end process;
end aaaa;