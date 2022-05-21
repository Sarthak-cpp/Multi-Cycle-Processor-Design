--Importing Libraries
library IEEE;
use IEEE.std_logic_1164.all; -- standard libraries
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;
--use work.MyTypes.all;--Importing MyTypes package as given on Moodle

--shift8 entity
entity shift8 is
port(
typee: in std_logic_vector(1 downto 0);
select3: in std_logic;
datain3: in std_logic_vector(31 downto 0);
dataout3: out std_logic_vector(31 downto 0)
);
end entity;
--shift8 shifts(or rotates) the input data(of a given type) by 8 bit given that the select bit is 1 


--architecture of the component
architecture bev of shift8 is
begin
process(typee,select3,datain3)
begin
case select3 is
when '0' =>
--Output the input data unaltered when select bit is 0
dataout3<=datain3;
when others =>
	case typee is
    when "01" =>
    --	Logical shift right when 01
    	dataout3(23 downto 0)<=datain3(31 downto 8);
		dataout3(31 downto 24)<="00000000";
	when "00" =>
    --	Logical shift left when 00
    	dataout3(31 downto 8)<=datain3(23 downto 0);
		dataout3(7 downto 0)<="00000000";
	when "10" =>
    --	Arithmetic shift right when 10
    	dataout3(23 downto 0)<=datain3(31 downto 8);
		if(datain3(31)='1') then
		dataout3(31 downto 24)<="11111111";--The msb is inserted to the left by the amount of shift (8 in this case)
		else
		dataout3(31 downto 24)<="00000000";
		end if;
	when others =>
    --	(Right) Rotation when 11
    	dataout3(23 downto 0)<=datain3(31 downto 8);
		dataout3(31 downto 24)<=datain3(7 downto 0);
	end case;
end case;
end process;
end bev;