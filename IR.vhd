library IEEE;
use IEEE.std_logic_1164.all; -- standard libraries
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;
use work.MyTypes.all;
entity IR is --The register IR as mentioned on page 30 of Lec10
	PORT(
        IW: IN STD_LOGIC;
        rd: in word;
        instruction: OUT word
        );
end IR;

Architecture irir of IR is
begin
Process(IW,rd)
begin
IF(IW = '1') THEN --Output only when set bit is 1
	instruction<=rd;
Else null;
end if;
end process;
end irir;