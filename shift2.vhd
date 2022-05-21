--Importing Libraries
library IEEE;
use IEEE.std_logic_1164.all; -- standard libraries
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;
--use work.MyTypes.all;--Importing MyTypes package as given on Moodle

--shift2 entity
entity shift2 is
port(
typee: in std_logic_vector(1 downto 0);
select1: in std_logic;
datain1: in std_logic_vector(31 downto 0);
dataout1: out std_logic_vector(31 downto 0)
);
end entity;
--shift2 shifts(or rotates) the input data(of a given type) by 2 bit given that the select bit is 1 


--architecture of the component
architecture bev of shift2 is
begin
process(typee,select1,datain1)
begin
case select1 is
when '0' =>
--Output the input data unaltered when select bit is 0
dataout1<=datain1;
when others =>
	case typee is
    when "01" =>
    --	Logical shift right when 01
    	dataout1(29 downto 0)<=datain1(31 downto 2);
		dataout1(31 downto 30)<="00";
	when "00" =>
    --	Logical shift left when 00
    	dataout1(31 downto 2)<=datain1(29 downto 0);
		dataout1(1 downto 0)<="00";
	when "10" =>
    --	Arithmetic shift right when 10
    	dataout1(29 downto 0)<=datain1(31 downto 2);
		if(datain1(31)='1') then
		dataout1(31 downto 30)<="11";--The msb is inserted to the left by the amount of shift (2 in this case)
		else
		dataout1(31 downto 30)<="00";
		end if;
	when others =>
    --	(Right) Rotation when 11
    	dataout1(29 downto 0)<=datain1(31 downto 2);
		dataout1(31 downto 30)<=datain1(1 downto 0);
	end case;
end case;
end process;
end bev;