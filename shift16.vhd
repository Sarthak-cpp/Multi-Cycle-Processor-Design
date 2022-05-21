--Importing Libraries
library IEEE;
use IEEE.std_logic_1164.all; -- standard libraries
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;
--use work.MyTypes.all;--Importing MyTypes package as given on Moodle

--shift16 entity
entity shift16 is
port(
typee: in std_logic_vector(1 downto 0);
select4: in std_logic;
datain4: in std_logic_vector(31 downto 0);
dataout4: out std_logic_vector(31 downto 0)
);
end entity;
--shift16 shifts(or rotates) the input data(of a given type) by 16 bit given that the select bit is 1 


--architecture of the component
architecture bev of shift16 is
begin
process(typee,select4,datain4)
begin
case select4 is
when '0' =>
--Output the input data unaltered when select bit is 0
dataout4<=datain4;
when others =>
	case typee is
    when "01" =>
    --	Logical shift right when 01
    	dataout4(15 downto 0)<=datain4(31 downto 16);
		dataout4(31 downto 16)<="0000000000000000";
	when "00" =>
    --	Logical shift left when 00
    	dataout4(31 downto 16)<=datain4(15 downto 0);
		dataout4(15 downto 0)<="0000000000000000";
	when "10" =>
    --	Arithmetic shift right when 10
    	dataout4(15 downto 0)<=datain4(31 downto 16);
		if(datain4(31)='1') then
		dataout4(31 downto 16)<="1111111111111111";--The msb is inserted to the left by the amount of shift (8 in this case)
		else
		dataout4(31 downto 16)<="0000000000000000";
		end if;
	when others =>
    --	(Right) Rotation when 11
    	dataout4(15 downto 0)<=datain4(31 downto 16);
		dataout4(31 downto 16)<=datain4(15 downto 0);
	end case;
end case;
end process;
end bev;