--Importing Libraries
library IEEE;
use IEEE.std_logic_1164.all; -- standard libraries
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;
--use work.MyTypes.all;--Importing MyTypes package as given on Moodle

--Gluing the 5 shifters together
entity shifter is
	port(
    	typee: in std_logic_vector(1 downto 0); --The type of shift(or rotation) to be performed
        datain: in std_logic_vector(31 downto 0); --The data to be shifted(or rotated)
        amount: in std_logic_vector(4 downto 0); --The amount by which shift(or rotation) occurs
        outpoot: out std_logic_vector(31 downto 0); --The output after shifting(or rotation)
        carryout: out std_logic --The carry output after shifting(or rotation)
        );
end entity;

architecture bev of shifter is

--Local signals declaration
signal datain0,datain1,datain2,datain3,datain4,dataout0,dataout1,dataout2,dataout3,dataout4: std_logic_vector(31 downto 0);
signal select0,select1,select2,select3,select4: std_logic;

--Component declarations
component shift1 is
    port(
    typee: in std_logic_vector(1 downto 0);
    select0: in std_logic;
    datain0: in std_logic_vector(31 downto 0);
    dataout0: out std_logic_vector(31 downto 0)
    );
    end component;

component shift2 is
    port(
    typee: in std_logic_vector(1 downto 0);
    select1: in std_logic;
    datain1: in std_logic_vector(31 downto 0);
    dataout1: out std_logic_vector(31 downto 0)
    );
    end component;

component shift4 is
    port(
    typee: in std_logic_vector(1 downto 0);
    select2: in std_logic;
    datain2: in std_logic_vector(31 downto 0);
    dataout2: out std_logic_vector(31 downto 0)
    );
    end component;

component shift8 is
    port(
    typee: in std_logic_vector(1 downto 0);
    select3: in std_logic;
    datain3: in std_logic_vector(31 downto 0);
    dataout3: out std_logic_vector(31 downto 0)
    );
    end component;

component shift16 is
    port(
        typee: in std_logic_vector(1 downto 0);
        select4: in std_logic;
        datain4: in std_logic_vector(31 downto 0);
        dataout4: out std_logic_vector(31 downto 0)
            );
    end component;

begin
--  Component instances
    comp1: shift1 port map(typee,select0,datain0,dataout0);
    comp2: shift2 port map(typee,select1,datain1,dataout1);
    comp3: shift4 port map(typee,select2,datain2,dataout2);
    comp4: shift8 port map(typee,select3,datain3,dataout3);
    comp5: shift16 port map(typee,select4,datain4,dataout4);

--shifting shifts(or roates) the datain by the given amount and outputs it in outpoot
shifting: process(amount,typee,datain,datain0,datain1,datain2,datain3,datain4,dataout0,dataout1,dataout2,dataout3,dataout4,select0,select1,select2,select3,select4)
    begin
    select0<=amount(0);
    select1<=amount(1);
    select2<=amount(2);
    select3<=amount(3);
    select4<=amount(4);
    datain0<=datain;
    datain1<=dataout0;
    datain2<=dataout1;
    datain3<=dataout2;
    datain4<=dataout3;
    outpoot<=dataout4;
    end process;

--carryshift determines the value of the carry after shift(rotation)
carryshift: process(amount,datain)
    begin
        if(typee="00") then
            carryout<=datain(conv_integer(amount));
           else
            carryout<=datain(conv_integer(amount)-1);
        end if;
    end process;
end bev;