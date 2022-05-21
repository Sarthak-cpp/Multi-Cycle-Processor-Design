library IEEE;
use IEEE.std_logic_1164.all; -- standard libraries
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;
use work.MyTypes.all;

--ALU entity
entity ALU IS
	PORT(
    	  op1 : IN word;
        op2 : IN word;
        result: OUT word;
        carryin: IN STD_LOGIC;
        carryout: OUT STD_LOGIC;
    	  operation: IN optype
        );
END ALU;

--ALU Architecture
Architecture BEV of ALU IS

Signal Temp: STD_LOGIC_VECTOR(32 downto 0);
Signal Temp1: STD_LOGIC_VECTOR(32 downto 0);
Signal Temp2: STD_LOGIC_VECTOR(32 downto 0);

begin
--Temporary Signals creation for carryout
Temp1(32)<='0';
Temp2(32)<='0';
Temp1(31 downto 0)<=op1;
Temp2(31 downto 0)<=op2;

PROCESS(op1,op2,carryin,operation)
Begin

	IF(operation=andop)THEN
      Temp<="000000000000000000000000000000000";
      carryout <= Temp(32);
      result <= op1 and op2; --AND operation
    ELSIF(operation=eor)THEN
      Temp<="000000000000000000000000000000000";
      carryout <= Temp(32);
      result <= op1 xor op2; --EOR operation
    ELSIF(operation=sub)THEN
      Temp<="000000000000000000000000000000000";
      carryout <= Temp(32);
      result <= op1 + (not op2) + 1; --Sub operation
    ELSIF(operation=rsb)THEN
      Temp<="000000000000000000000000000000000";
      carryout <= Temp(32);
      result <= (not op1) + op2 + 1; --Rsub operation
    ELSIF(operation=add)THEN
      Temp<="000000000000000000000000000000000";
      carryout <= Temp(32);
      result <= op1 + op2; --Add operation
    ELSIF(operation=adc)THEN
      Temp <= Temp1 + Temp2 + carryin; --Addc operation
      result <= Temp (31 downto 0);
    ELSIF(operation=sbc)THEN
      Temp <= Temp1 + (not Temp2) + carryin; --Sbc operation
      result <= Temp(31 downto 0);
      carryout <= Temp(32);
    ElSIF(operation=rsc)THEN
      Temp <= (not Temp1) + Temp2 + carryin; --RSc operation
      result <= Temp(31 downto 0);
      carryout <= Temp(32);
    ELSIF(operation=tst)THEN
      Temp<="000000000000000000000000000000000";
      carryout <= Temp(32);
      result <= op1 and op2; --tst operation
    ELSIF(operation=teq)THEN
      Temp<="000000000000000000000000000000000";
      carryout <= Temp(32);
      result <= op1 xor op2; --teq operation
    ELSIF(operation=cmp)THEN
      Temp<="000000000000000000000000000000000";
      carryout <= Temp(32);
      result <= op1 + (not op2) + 1; --cmp operation
    ELSIF(operation=cmn)THEN
      Temp<="000000000000000000000000000000000";
      carryout <= Temp(32);
      result <= op1 + op2; --cmn operation
    ELSIF(operation=orr)THEN
      Temp<="000000000000000000000000000000000";
      carryout <= Temp(32);
      result <= op1 or op2; --orr operation
    ELSIF(operation = mov)THEN
      Temp<="000000000000000000000000000000000";
      carryout<='0';
      result <= op1; --mov operation
    ELSIF(operation = bic)THEN
      Temp<="000000000000000000000000000000000";
      carryout <= Temp(32);
      result <= op1 and (not op2); --bic operation
    ELSE
      Temp<="000000000000000000000000000000000";
      carryout <= Temp(32);
      result <= not op2; -- mvn operation
    END IF;
    END PROCESS;
END BEV;