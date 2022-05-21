library IEEE;
use IEEE.std_logic_1164.all; -- standard libraries
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;
use work.MyTypes.all;
--THe program counter for our Processor
entity PC is
	PORT(
        PW: IN STD_LOGIC; --Write Enable
        result: in word;
        PC_out: OUT STD_LOGIC_VECTOR(31 downto 0)
        );
end PC;

Architecture pcpc of PC is
begin
Process(PW,result)
begin
IF(PW = '1') THEN
	PC_out<=result;--PC outputted only when set bit is 1
Else null;
end if;
end process;
end pcpc;