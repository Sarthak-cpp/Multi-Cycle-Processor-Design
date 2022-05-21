library IEEE;
use IEEE.std_logic_1164.all; -- standard libraries
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;
use work.MyTypes.all;
entity RES is
	PORT(
        ReW: IN STD_LOGIC;
        result: in word;
        RES_out: OUT word
        );
end RES;

Architecture resres of RES is
begin
Process(ReW)
begin
IF(ReW = '1') THEN
	RES_out<=result;
Else null;
end if;
end process;
end resres;