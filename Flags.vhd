library IEEE;
use IEEE.std_logic_1164.all; -- standard libraries
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;
use work.MyTypes.all;
-- Flag_Out = C,V,Z,N
entity Flags is
	PORT(
    	Flag_Out: OUT STD_LOGIC_VECTOR(3 downto 0);
        Fset: IN std_logic;
        carryout: IN STD_LOGIC;
        op1: IN STD_LOGIC_VECTOR(31 downto 0);
        op2: IN STD_LOGIC_VECTOR(31 downto 0);
        operation: IN optype;
        result: IN STD_LOGIC_VECTOR(31 downto 0)
        );
end Flags;
--Takes in results and inputs of ALU along with a set bit for Flags and outputs the current values of the Flags

Architecture BEV of Flags is

begin
	Flag_Out(3)<=carryout;
    Process(carryout,op1,op2,operation,result)
    begin
    if (Fset = '1') then
            IF(result = "00000000000000000000000000000000")THEN
        	Flag_Out(1)<='1'; --Zero Flag activated when result from ALU is 0
        Else Flag_Out(1)<='0';
        end if;
        --Conditions for Overflow flag, depending upon the ALU operations and outputs
        IF(operation = sub or operation=cmp) THEN
        	Flag_Out(2)<=op1(31) xor (not op2(31)) xor result(31) xor carryout;
        ELSIF(operation =  sbc)THEN
        	Flag_Out(2)<=op1(31) xor (not op2(31)) xor result(31) xor carryout;
        ELSIF(operation = rsb) THEN
        	Flag_Out(2)<=(not op1(31)) xor op2(31) xor result(31) xor carryout;
        ELSIF(operation = rsc)THEN
        	Flag_Out(2)<=(not op1(31)) xor op2(31) xor result(31) xor carryout;
        Else Flag_Out(2)<=op1(31) xor op2(31) xor result(31) xor carryout;
        end if;
        IF(result(31) = '1') THEN
        	Flag_Out(0)<='1';--Negative Flag activated when the left most bit is 1
        Else Flag_Out(0)<='0';
        end if;
    end if ;
    
    end process;
end BEV;