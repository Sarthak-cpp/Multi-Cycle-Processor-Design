--Importing Libraries
library IEEE;
use IEEE.std_logic_1164.all; -- standard libraries
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;
--use work.MyTypes.all;--Importing MyTypes package as given on Moodle

--shift1 entity
entity shift1 is
port(
typee: in std_logic_vector(1 downto 0);
select0: in std_logic;
datain0: in std_logic_vector(31 downto 0);
dataout0: out std_logic_vector(31 downto 0)
);
end entity;
--shift1 shifts(or rotates) the input data(of a given type) by 1 bit given that the select bit is 1 


--architecture of the component
architecture bev of shift1 is
begin
process(typee,select0,datain0)
begin
case select0 is
when '0' =>
--Output the input data unaltered when select bit is 0
dataout0<=datain0;
when others =>
	case typee is
    when "01" =>
    --	Logical shift right when 01
    	dataout0(30 downto 0)<=datain0(31 downto 1);
		dataout0(31)<='0';
	when "00" =>
    --	Logical shift left when 00
    	dataout0(31 downto 1)<=datain0(30 downto 0);
		dataout0(0)<='0';
	when "10" =>
    --	Arithmetic shift right when 10
    	dataout0(30 downto 0)<=datain0(31 downto 1);
		if(datain0(31)='1') then
		dataout0(31)<='1';--The msb is inserted to the left by the amount of shift (1 in this case)
		else
		dataout0(31)<='0';
		end if;
	when others =>
    --	(Right) Rotation when 11
    	dataout0(30 downto 0)<=datain0(31 downto 1);
		dataout0(31)<=datain0(0);
	end case;
end case;
end process;
end bev;