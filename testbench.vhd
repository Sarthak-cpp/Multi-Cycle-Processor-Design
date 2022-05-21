library IEEE;
use IEEE.std_logic_1164.all; -- standard libraries
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;
use work.MyTypes.all;
entity testbench is
end entity;

architecture tb of testbench is

Signal Clk: STD_LOGIC:='0';
Signal Reset: STD_LOGIC:='1';

component MyDesign is
	PORT(
    	Clk: IN STD_LOGIC;
        Reset: IN STD_LOGIC
        );
end component;

begin

UUT: MyDesign port map(Clk,Reset);
Clock: Process
begin
    Clk<='0';
    wait for 10 ns;
    Clk<='1';
    wait for 10 ns;
end process;
Process
begin
	wait for 10 ns;
	reset<='0';
	wait for 10 ns;
	reset<='0';
	wait for 10 ns;
	reset<='0';
	wait for 10 ns;
	reset<='0';
	wait for 10 ns;
	reset<='0';
	wait for 10 ns;
	reset<='0';
	wait for 10 ns;
	reset<='0';
	wait for 10 ns;
	reset<='0';
	wait for 10 ns;
	reset<='0';
	wait for 10 ns;
	reset<='0';
	wait for 10 ns;
	reset<='1';
	wait for 10 ns;
	reset<='0';
	wait;
end process;
end tb;