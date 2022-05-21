--Importing Libraries
library IEEE;
use IEEE.std_logic_1164.all; -- standard libraries
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;
--use work.MyTypes.all;--Importing MyTypes package as given on Moodle

--shift4 entity
entity shift4 is
port(
typee: in std_logic_vector(1 downto 0);
select2: in std_logic;
datain2: in std_logic_vector(31 downto 0);
dataout2: out std_logic_vector(31 downto 0)
);
end entity;
--shift4 shifts(or rotates) the input data(of a given type) by 4 bit given that the select bit is 1 


--architecture of the component
architecture bev of shift4 is
begin
process(typee,select2,datain2)
begin
case select2 is
when '0' =>
--Output the input data unaltered when select bit is 0
dataout2<=datain2;
when others =>
	case typee is
    when "01" =>
    --	Logical shift right when 01
    	dataout2(27 downto 0)<=datain2(31 downto 4);
		dataout2(31 downto 28)<="0000";
	when "00" =>
    --	Logical shift left when 00
    	dataout2(31 downto 4)<=datain2(27 downto 0);
		dataout2(3 downto 0)<="0000";
	when "10" =>
    --	Arithmetic shift right when 10
    	dataout2(27 downto 0)<=datain2(31 downto 4);
		if(datain2(31)='1') then
		dataout2(31 downto 28)<="1111";--The msb is inserted to the left by the amount of shift (4 in this case)
		else
		dataout2(31 downto 28)<="0000";
		end if;
	when others =>
    --	(Right) Rotation when 11
    	dataout2(27 downto 0)<=datain2(31 downto 4);
		dataout2(31 downto 28)<=datain2(3 downto 0);
	end case;
end case;
end process;
end bev;