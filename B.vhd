library IEEE;
use IEEE.std_logic_1164.all; -- standard libraries
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;
use work.MyTypes.all;
entity B is
	PORT(
        BW: IN STD_LOGIC;
        rd2: in word;
        B_out: OUT word
        );
end B;

Architecture bbb of B is
begin
Process(BW,rd2)
begin
IF(BW = '1') THEN
	B_out<=rd2;
Else null;
end if;
end process;
end bbb;