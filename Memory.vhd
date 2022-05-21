library IEEE;
use IEEE.std_logic_1164.all; -- standard libraries
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;
use work.MyTypes.all;

--The memory unit of our Processor
entity Memory is
  port (
      Clk: in std_logic;
      ad: in std_logic_vector(6 downto 0);--The address to output or write data
      wdm: in word; --The data to be written
      MW: in std_logic; --Write Enable
      rd: out word --The data to be outputted
  );
end Memory;

architecture arch of Memory is
TYPE MEM IS ARRAY (127 DOWNTO 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL MEMORY : MEM:=(X"E3A00030",
X"E3A0105A",
X"E0802001",
X"E0413000",
X"E0014000",
X"E1815000",
X"E0216000",
X"E0917000",
X"E0508001",
X"E1700001",
X"E1500001",
X"E3E03038",
others => x"00000000"
);--Memory Initialization
Begin
	Process(MW,Clk,ad,wdm)
    variable ADDR : INTEGER RANGE 0 TO 127;
    Begin
    ADDR:=CONV_INTEGER(ad);
    IF(MW = '1')then
    	MEMORY(ADDR)<=wdm;--Write and output when write enable is 1
        rd<=MEMORY(ADDR);
    ELSE rd<=MEMORY(ADDR); --Otherwise just output the answer
    end if;
    end process;
end arch;