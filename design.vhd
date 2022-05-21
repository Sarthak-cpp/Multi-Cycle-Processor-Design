library IEEE;
use IEEE.std_logic_1164.all; -- standard libraries
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;
use work.MyTypes.all;
entity MyDesign is
    port(
        Clk,Reset : in std_logic
    );
end MyDesign;
architecture behavioral of MyDesign is
    -- declaration of local signals
    signal lorD, M2R, Asrc1, Rsrc: std_logic; --The multiplexers as defined on page 30 of lecture 10
    signal Asrc2: bit_pair;--Another Multiplexer
    signal instr_class: instr_class_type;
    signal operation: optype;
    signal myNewOperation: optype;
    signal DP_subclass: DP_subclass_type;
    signal DP_operand_src: DP_operand_src_type;
    signal load_store: load_store_type;
    signal DT_offset_sign: DT_offset_sign_type;
    signal Fset: std_logic;
    signal typee: std_logic_vector(1 downto 0);
    signal datain: std_logic_vector(31 downto 0);
    signal amount: std_logic_vector(4 downto 0);
    signal select0,select1,select2,select3,select4: std_logic;
    signal datain0,datain1,datain2,datain3,datain4,dataout0,dataout1,dataout2,dataout3,dataout4,outpoot: std_logic_vector(31 downto 0);
    Signal op1,op2,result,wdm,A_out,B_out,RES_out,instruction,DR_out,PC_out,rd2,rd1,wd,rd: word:=X"00000000";
    Signal ReW,BW,DW,AW,IW,carryout,PW,RW,MW,Predicate,carryin: STD_LOGIC;
    Signal Flag_Out,wad,rad1,rad2: nibble;
    Signal ad: STD_LOGIC_VECTOR(6 downto 0);
    Signal Cond: STD_LOGIC_VECTOR(1 downto 0);
    Signal State: INTEGER range 0 to 8;
    Signal EX: word:="00000000000000000000000000000000";
    Signal S2: word:="00000000000000000000000000000000";
    signal control_state: std_logic_vector(3 downto 0):=(others=>'0');--The control state FSM(DFA)
    signal Rgd,Rn,Rm: INTEGER range 0 to 15;
    signal Imm8: byte;--Immediate
    signal Offset: std_logic_vector(11 downto 0);
    signal S_offset: std_logic_vector(23 downto 0);
--component declarations
component ALU IS--ALU Declaration
PORT(
    op1 : IN word;
    op2 : IN word;
    result: OUT word;
    carryin: IN STD_LOGIC;
    carryout: OUT STD_LOGIC;
	operation: IN optype
    );
END component;
component Memory is--Memory Declaration
    port (
        Clk: in std_logic;
        ad: in std_logic_vector(6 downto 0);
        wdm: in word;
        MW: in std_logic;
        rd: out word
    );
  end component;
component Decoder is--Decoder Declaration
    Port (
   instruction : in word;
   instr_class : out instr_class_type;
   myNewOperation : out optype;
   DP_subclass : out DP_subclass_type;
   DP_operand_src : out DP_operand_src_type;
   load_store : out load_store_type;
   DT_offset_sign : out DT_offset_sign_type
   );
   end component;
   component RegisterFiles IS--RegisterFiles Declaration
   PORT(
       rad1: IN nibble;
       rad2: IN nibble;
       wad: IN nibble;
       Clk: IN STD_LOGIC;
       RW: IN STD_LOGIC;
       wd: IN word;
       rd1: OUT word;
       rd2: OUT word
       );
END component;
component A is--A as defined on page 30 of lecture 10
	PORT(
        AW: IN STD_LOGIC;
        rd1: in word;
        A_out: OUT word
        );
end component;
component B is--B as defined on page 30 of lecture 10
    port(
        BW: in std_logic;
        rd2: in word;
        B_out: out word
    );
end component;
component RES is--RES as defined on page 30 of lecture 10
	PORT(
        ReW: IN STD_LOGIC;
        result: in word;
        RES_out: OUT word
        );
end component;
component IR is--IR as defined on page 30 of lecture 10
	PORT(
        IW: IN STD_LOGIC;
        rd: in word;
        instruction: OUT word
        );
end component;
component DR is--DR as defined on page 30 of lecture 10
	PORT(
        DW: IN STD_LOGIC;
        rd: in word;
        DR_out: OUT word
        );
end component;
component PC is--Program Counter Declaration
    PORT(
        PW: IN STD_LOGIC;
        result: in word;
        PC_out: OUT STD_LOGIC_VECTOR(31 downto 0)
        );
end component;
component Flags is--Flag declaration
	PORT(
    	Flag_Out: OUT STD_LOGIC_VECTOR(3 downto 0);
        Fset: in std_logic;
        carryout: IN STD_LOGIC;
        op1: IN STD_LOGIC_VECTOR(31 downto 0);
        op2: IN STD_LOGIC_VECTOR(31 downto 0);
        operation: IN optype;
        result: IN STD_LOGIC_VECTOR(31 downto 0)
        );
end component;
component ConditionChecker is--Condition Checker declaration
	Port(
    	Flag_Out: IN STD_LOGIC_VECTOR(3 downto 0);
        Cond: IN STD_LOGIC_VECTOR(1 downto 0);
        Predicate: OUT STD_LOGIC
        );
END component;
component shift1 is--Newly created component Shift1
    port(
    typee: in std_logic_vector(1 downto 0);
    select0: in std_logic;
    datain0: in std_logic_vector(31 downto 0);
    dataout0: out std_logic_vector(31 downto 0)
    );
    end component;

component shift2 is--Newly created component Shift2
    port(
    typee: in std_logic_vector(1 downto 0);
    select1: in std_logic;
    datain1: in std_logic_vector(31 downto 0);
    dataout1: out std_logic_vector(31 downto 0)
    );
    end component;

component shift4 is--Newly created component Shift4
    port(
    typee: in std_logic_vector(1 downto 0);
    select2: in std_logic;
    datain2: in std_logic_vector(31 downto 0);
    dataout2: out std_logic_vector(31 downto 0)
    );
    end component;

component shift8 is--Newly created component Shift8
    port(
    typee: in std_logic_vector(1 downto 0);
    select3: in std_logic;
    datain3: in std_logic_vector(31 downto 0);
    dataout3: out std_logic_vector(31 downto 0)
    );
    end component;

component shift16 is--Newly created component Shift16
    port(
        typee: in std_logic_vector(1 downto 0);
        select4: in std_logic;
        datain4: in std_logic_vector(31 downto 0);
        dataout4: out std_logic_vector(31 downto 0)
            );
    end component;
component shifter is--Newly created component Shifter, glues the above 5
	port(
    	typee: in std_logic_vector(1 downto 0); --The type of shift(or rotation) to be performed
        datain: in std_logic_vector(31 downto 0); --The data to be shifted(or rotated)
        amount: in std_logic_vector(4 downto 0); --The amount by which shift(or rotation) occurs
        outpoot: out std_logic_vector(31 downto 0); --The output after shifting(or rotation)
        carryout: out std_logic --The carry output after shifting(or rotation)
        );
end component;

    begin
    -- component instances
    comp1: ALU port map(op1,op2,result,carryin,carryout,operation);
    comp2: Memory port map(Clk,ad,wdm,MW,rd);
    comp3: Decoder port map(instruction,instr_class,myNewOperation,DP_subclass,DP_operand_src,load_store,DT_offset_sign);
    comp4: RegisterFiles port map(rad1,rad2,wad,Clk,RW,wd,rd1,rd2);
    comp5: A port map(AW,rd1,A_out);
    comp6: B port map(BW,rd2,B_out);
    comp7: RES port map(ReW,result,RES_out);
    comp8: IR port map(IW,rd,instruction);
    comp9: DR port map(DW,rd,DR_out);
    comp10: PC port map(PW,result,PC_out);
    comp11: Flags port map(Flag_Out,Fset,carryout,op1,op2,operation,result);
    comp12: ConditionChecker port map(Flag_Out,Cond,Predicate);
    comp13: shifter port map(typee,datain,amount,outpoot,carryout);
    comp14: shift1 port map(typee,select0,datain0,dataout0);
    comp15: shift2 port map(typee,select1,datain1,dataout1);
    comp16: shift4 port map(typee,select2,datain2,dataout2);
    comp17: shift8 port map(typee,select3,datain3,dataout3);
    comp18: shift16 port map(typee,select4,datain4,dataout4);
    -- concurrent assignments for extracting instruction fields
    Rgd <= to_integer (unsigned(instruction (15 downto 12)));
    Rn <= to_integer (unsigned(instruction (19 downto 16)));
    Rm <= to_integer (unsigned(instruction (3 downto 0)));
    Imm8 <= instruction (7 downto 0); 
    Offset <= instruction (11 downto 0); 
    S_offset <= instruction (23 downto 0);
    Cond<= instruction(29 downto 28);
    Fset<=instruction(20);
    -- control signals and multiplexers
todo:    process (op1,op2,result,carryin,carryout,operation,Clk,ad,wdm,MW,rd,instruction,instr_class,myNewOperation,DP_subclass,DP_operand_src,load_store,DT_offset_sign,rad1,rad2,wad,RW,wd,rd1,rd2,AW,
                 A_out,BW,B_out,ReW,RES_out,IW,DW,DR_out,PW,PC_out,Flag_Out,Fset,Cond,Predicate,typee,datain,amount,outpoot
                 ,select0,datain0,dataout0,select1,datain1,dataout1,select2,datain2,dataout2,select3,datain3,dataout3,select4,datain4,dataout4)
    begin
    -- default values
    PW <= '0';
    lord<='0'; MW<= '0';
    result<="00000000000000000000000000000000";
    PC_out<="00000000000000000000000000000000";
    IW<='0';
    op1 <= A_out;
    op2 <= B_out;
    carryin <= Flag_Out(1);
    rad2 <= std_logic_vector(to_unsigned(Rm,rad2'length));
    rad1 <= std_logic_vector(to_unsigned(Rn,rad1'length));
    if(Rsrc='1') then--Multiplexer conditions
        rad1<=instruction(19 downto 16);
        rad2<=instruction(15 downto 12);
    else 
        rad1<=instruction(19 downto 16);
        rad2<=instruction(3 downto 0);
    end if;
    wad<=instruction(15 downto 12);
    if(M2R = '1') then--Multiplexer conditions
        wd<=DR_out;
    else wd<=RES_out;
    end if;
    if(Asrc1 = '0') then--Multiplexer conditions
        op1<="00" & PC_out(31 downto 2);
    else op1<=A_out;
    end if;
    if(Asrc2="00") then--Multiplexer conditions
        op2<=B_out;
    elsif(Asrc2="01") then--Multiplexer conditions
        op2<=x"00000001";
    elsif(Asrc2="10") then--Multiplexer conditions
        op2<=x"00000"&instruction(11 downto 0);
    else 
        if(instruction(23)='1') then
            op2<=x"ff" & instruction(23 downto 0);
        else op2<=x"00" & instruction(23 downto 0);
        end if;
    end if;
    if(Asrc2="11") then --Multiplexer conditions
    	carryin<='1';
    else carryin<=Flag_Out(3);
    end if;
    wdm<=B_out;
    end process;
    -- control FSM
state:    process (Clk, reset,PW,lord,MW,IW,DW,M2R,Rsrc,RW,AW,BW,Asrc1,Asrc2,operation,Fset,ReW,caryyin,control_state,myNewOperation)--Process to manage control states(FSM)
    begin
    if (reset ='1') then
        control_state <= "0000";
        PC_out<=X"00000000";
    elsif rising_edge(Clk) then
    case control_state is
    when "0000" => --The state to increment program counter
    PW<='1';
    lord<='0';
    MW<='0';
    IW<='1';
    DW<='0';
    M2R<='0';
    Rsrc<='0';
    RW<='0';
    AW<='0';
    BW<='0';
    Asrc1<='0';
    Asrc2<="01";
    operation<=add;
    Fset<='0';
    ReW<='0';
    carryin<='0';
    control_state <= "0001";
    when "0001" => --state to read A and B
    operation <= myNewOperation;
    IW<='0';
    lord<='0';
    AW<='1';
    BW<='1';
    PW<='0';
    MW<='0';
    DW<='0';
    RW<='0';
    ReW<='0';
    M2R<='0';
    Fset<='0';
    carryin<='0';
    Asrc1<='0';
    Asrc2<="00";   
    if(instr_class=DP or instructionclass=DT) then
            control_state<="1001";--Go to this state to check shifting
            end if;
    if(instr_class = DP)THEN
    	Rsrc<='0';
    elsif(instr_class = DT)then
    	Rsrc<='1';
    else
    control_state<="0100"; --Go to this state for branching
    Rsrc<='1';
    end if;
    when "0010" => --Taking out result and flags from ALU
    operation <= myNewOperation;
    control_state<="0101";
    AW<='0';
    BW<='0';
    PW<='0';
    MW<='0';
    IW<='0';
    lord<='0';
    DW<='0';
    M2R<='0';
    Rsrc<='0';
    carryin<='0';
    ReW<='1';
    RW<='0';
    Asrc1<='1';
    Fset<='1';
    if(DP_operand_src = reg)then
    	Asrc2<="00";
    elsif(DP_operand_src = imm)then
    	Asrc2<="10";
    end if;
    when "0011" => --DP state
    Asrc1<='1';
    Asrc2<="10";
    Rsrc<='1';
    ReW<='1';
    RW<='0';
    PW<='0';
    BW<='0';
    AW<='0';
    lord<='0';
    MW<='0';
    IW<='0';
    DW<='0';
    M2R<='0';
    Fset<='0';
    carryin<='0';
    if(load_store = load)then
    	control_state<="0111";
    elsif(load_store = store)then
    	control_state<="0110";
    end if;
    if(DT_offset_sign = plus)then
    	operation <= add;
    elsif(DT_offset_sign = minus)then
    	operation <= sub;
    end if;
    when "0110" => --DT state
    operation <= myNewOperation;
        control_state<="0000";
        carryin<='0';
        Asrc2<="00";
        ReW<='0';
        Fset<='0';
        Asrc1<='0';
        RW<='0';
        AW<='0';
        M2R<='0';
        DW<='0';
        IW<='0';
        PW<='0';
        BW<='0';
        Rsrc<='1';
        lord<='1';
        MW<='1';
    when "0101" => --Branching State
    operation <= myNewOperation;
    	if(operation=tst or operation=teq or  operation=cmn or operation=cmp)THEN
             RW<='0';
        else RW<='1';
        end if;
        control_state<="0000";
        AW<='0';
        BW<='0';
        PW<='0';
        lord<='0';
        MW<='0';
        IW<='0';
        DW<='0';
        ReW<='0';
        Fset<='0';
        Asrc1<='0';
        Asrc2<="00";
        Rsrc<='0';
        carryin<='0';
    when "0111" => --DP result storing
    operation <= myNewOperation;
        control_state<="1000";
        DW<='1';
        lord<='1';
        Rsrc<='1';
        carryin<='0';
        Asrc2<="00";
        ReW<='0';
        Fset<='0';
        Asrc1<='0';
        RW<='0';
        AW<='0';
        M2R<='0';
        IW<='0';
        MW<='0';
        PW<='0';
        BW<='0';
    when "1000" => --DT
    operation <= myNewOperation;
        control_state<="0000";
        BW<='0';
        PW<='0';
        lord<='0';
        M2R<='1';
        Rsrc<='1';
        RW<='1';
        MW<='0';
        IW<='0';
        DW<='0';
        Fset<='0';
        Asrc1<='0';
        AW<='0';
        ReW<='0';
        Asrc2<="00";
        carryin<='0';
    when "0100" => --DT
    operation <= myNewOperation;
        control_state<="0000";
        operation<=adc;
        Asrc1<='0';
        Rsrc<='1';
        Asrc2<="11";
        PW<=Predicate;
        carryin<='1';
        BW<='0';
        lord<='0';
        MW<='0';
        IW<='0';
        DW<='0';
        M2R<='0';
        AW<='0';
        RW<='0';
        Fset<='0';
        ReW<='0';
    when "1001" => --Newly created state for shift/rotate
    	control_state<="1010";
        AW<='0';
        BW<='0';
        PW<='0';
        MW<='0';
        DW<='0';
        M2R<='0';
        RW<='0';
        Asrc1<='0';
        Fset<='0';
        Rsrc<='1';
        carryin<='0';
        ReW<='0';
        Asrc2<="00";
    when "1010" => --Newly created state for shift/rotate
    	if(instr_class = DP) then
        	control_state<="0010";
        	Rsrc<='0';
        elsif(instr_class = DT) then
        	control_state<="0011";
            Rsrc<='0';
        end if;
        AW<='0';
        BW<='0';
        PW<='0';
        MW<='0';
        DW<='0';
        M2R<='0';
        RW<='0';
        Asrc1<='0';
        Fset<='0';
        Rsrc<='1';
        carryin<='0';
        ReW<='0';
        Asrc2<="00";
    when others =>
    operation <= myNewOperation;
    control_state<="1111";
    end case;
    end if;
    end process;
    end behavioral;