library IEEE;
use IEEE.std_logic_1164.all; -- standard libraries
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;
use work.MyTypes.all;

--Condition Checker for branch instructions
entity ConditionChecker is
	Port(
    	Flag_Out: IN STD_LOGIC_VECTOR(3 downto 0);--The Flag values
        Cond: IN STD_LOGIC_VECTOR(1 downto 0);--28th and 29th bits of instruction
        Predicate: OUT STD_LOGIC
        --Branch when predicate is 1, else don't branch
        );
END ConditionChecker;

ARCHITECTURE BEV OF ConditionChecker IS
Signal Z: STD_LOGIC;
begin
Z<=Flag_Out(1);--Z is the zero flag
	Process(Z,Cond)
    begin
	IF(Cond = "10")THEN
    Predicate<='1';
    ELSIF(Cond = "00")THEN
    Predicate<=Z;
    ELSIF(Cond = "01")THEN
    Predicate<=(not Z);
    ELSE Predicate<='0';
    end if;
    end process;
END BEV;