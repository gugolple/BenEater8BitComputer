----------------------------------------------------------------------------------
-- Company: MyOwnBoredom
-- Engineer: Gugolple
-- 
-- Create Date: 03/18/2023 01:06:06 PM
-- Module Name: interconection_bus - Behavioral
-- Project Name: BenEater8BitComputer
-- Description: This module will interconect all elements within the sistem as 
--     a separate unit for clarity.
--
--     The modules are expected to assert output at rising edge of clk and to 
--     store the input at the falling edge, as to allow time for signals to
--     stabilize.
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.all;

entity interconection_bus is
    Generic(
        bit_size : integer := constants.bit_width 
    );
    Port (
        external_clk : in std_logic;
        reset : in std_logic;
        output : out std_logic_vector(bit_size -1 downto 0)
    );
end interconection_bus;

architecture Behavioral of interconection_bus is

-- Clock handling resource
component clock_managment is
  Port (
    -- clk is the crystal oscillator
    clk : in std_logic;
    -- reset
    reset : in std_logic;
    -- halt signal, to stop the clock
    halt : in std_logic;
    -- clk output from the control unit
    clk_out : out std_logic
   );
end component;
signal clk : std_logic;

-- Register for output value
component register_unit is
  Generic (
    bit_size : integer := bit_size
  );
  Port (
    clk : in std_logic;
    reset : in std_logic;
    load : in std_logic;
    data_in : in std_logic_vector(bit_size -1 downto 0);
    data_out : out std_logic_vector(bit_size -1 downto 0)
  );
end component;
signal data_from_register_out : std_logic_vector(bit_size -1 downto 0);

-- Program counter module
component registered_program_counter is
    Generic(
        bit_size : integer := bit_size 
    );
    Port(
    -- Register part
        clk : in std_logic;
        load : in std_logic;
        data_in : in std_logic_vector(bit_size -1 downto 0);
    -- Program counter part
        enable : in std_logic;
        set : in std_logic;
        reset : in std_logic;
        out_counter : out std_logic_vector(bit_size -1 downto 0)
    );
end component;
signal data_from_program_counter : std_logic_vector(bit_size -1 downto 0);

-- Main memory module
component registered_main_memory is
    Generic(
        bit_size : integer := bit_size 
    );
    Port(
    -- Register part
        clk : in std_logic;
        reset : in std_logic;
        load : in std_logic;
        data_in : in std_logic_vector(bit_size -1 downto 0);
    -- Main memory part
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
end component;
signal data_from_main_memory : std_logic_vector(bit_size -1 downto 0);

-- Alu module
component registered_alu is
    Generic(
        bit_size : integer := bit_size 
    );
    Port(
    -- Register part
        clk : in std_logic;
        reset : in std_logic;
        load_a : in std_logic;
        register_a : in std_logic_vector(bit_size -1 downto 0);
        register_a_out : out std_logic_vector(bit_size -1 downto 0);
        load_b : in std_logic;
        register_b : in std_logic_vector(bit_size -1 downto 0);
    -- Alu part
        substraction : in std_logic;
        flag_zero : out std_logic;
        flag_carry : out std_logic;
        output : inout std_logic_vector(constants.bit_width -1 downto 0)
    );
end component;
signal data_from_register_a : std_logic_vector(bit_size -1 downto 0);
signal data_from_alu : std_logic_vector(bit_size -1 downto 0);

-- Control unit module
component registered_control_unit is
    Generic(
        bit_size : integer := bit_size
    );
    Port(
    -- Register part
        clk : in std_logic;
        load : in std_logic;
        data_in : in std_logic_vector(bit_size -1 downto 0);
    -- Control unit part
        -- Input signals
        reset : in std_logic;
            -- CPU control signals
                -- Get alu flags for flow control
                alu_flag_zero : in std_logic;
                alu_flag_carry : in std_logic;
         -- Output signals
            intruction_data : out std_logic_vector(constants.bit_width -1 downto 0);
            -- Main CPU signals
                soft_reset : out std_logic;
                halt : out std_logic;
                -- Set the ALU to substraction mode
                alu_substraction : out std_logic;
            -- BUS transfer signals
                -- From ram into the bus
                ram_in : out std_logic;
                -- From bus into ram
                ram_write : out std_logic;
                -- From bus into ram address
                ram_address : out std_logic;
                -- From instruction register into bus
                register_instruction_in : out std_logic;
                -- From bus into intruction register
                register_instruction_out : out std_logic;
                -- From bus into register A
                register_a_out : out std_logic;
                -- From register A into bus
                register_a_in : out std_logic;
                -- From bus into register B
                register_b_out : out std_logic;
                -- From bus into register OUTPUT
                register_output_out : out std_logic;
                -- Set program counter to program counter register
                jump : out std_logic;
                -- Advance program counter
                program_counter_advance : out std_logic;
                -- From bus into program counter
                program_counter_out : out std_logic;
                -- From program counter into bus
                program_counter_in : out std_logic;
                -- From alu into bus
                alu_in : out std_logic
    );
end component;
signal data_from_control_unit : std_logic_vector(bit_size -1 downto 0);  
-- Control signals
  -- Main CPU signals
    signal soft_reset : std_logic;
    signal halt : std_logic;
    -- CPU control signals
        -- Get alu flags for flow control
        signal alu_flag_zero : std_logic;
        signal alu_flag_carry : std_logic;
  -- BUS transfer signals
    -- From ram into the bus
    signal ram_in : std_logic;
    -- From bus into ram
    signal ram_write : std_logic;
    -- From bus into ram address
    signal ram_address : std_logic;
    -- From instruction register into bus
    signal register_instruction_in : std_logic;
    -- From bus into intruction register
    signal register_instruction_out : std_logic;
    -- From bus into register A
    signal register_a_in : std_logic;
    -- From register A into bus
    signal register_a_out : std_logic;
    -- From bus into register B
    signal register_b_out : std_logic;
    -- From bus into register OUTPUT
    signal register_output_out : std_logic;
    -- Set program counter to program counter register
    signal jump : std_logic;
    -- Advance program counter
    signal program_counter_advance : std_logic;
    -- From bus into program counter
    signal program_counter_in : std_logic;
    -- From program counter into bus
    signal program_counter_out : std_logic;
    -- From alu into bus
    signal alu_in : std_logic;
  -- CPU control signals
    -- Set the ALU to substraction mode
    signal alu_substraction : std_logic;

signal local_bus : std_logic_vector(bit_size -1 downto 0);

-------------------------------------------------------------------------------
-- Start instantiations of elements and interconections. ----------------------
-------------------------------------------------------------------------------
begin

clock_managment_instance : clock_managment
    Port map(   
        -- clk is the crystal oscillator
        clk => external_clk,
        -- reset
        reset => reset,
        -- halt signal, to stop the clock
        halt => halt,
        -- clk output from the control unit
        clk_out => clk
    );

registered_control_unit_instance : registered_control_unit 
    Generic map (bit_size => bit_size)
    Port map(
    -- Register part
        clk => clk,
        load => register_instruction_out,
        data_in => local_bus,
        -- CPU control signals
            -- Get alu flags for flow control
            alu_flag_zero => alu_flag_zero,
            alu_flag_carry => alu_flag_carry,
            -- Set the ALU to substraction mode
            alu_substraction => alu_substraction,
    -- Control unit part
            reset => reset,
            intruction_data => data_from_control_unit,
        -- Output signals
            -- Main CPU signals
                soft_reset => soft_reset,
                halt => halt,
            -- BUS transfer signals
                -- From ram into the bus
                ram_in => ram_in,
                -- From bus into ram
                ram_write => ram_write,
                -- From bus into ram address
                ram_address => ram_address,
                -- From instruction register into bus
                register_instruction_in => register_instruction_in,
                -- From bus into intruction register
                register_instruction_out => register_instruction_out,
                -- From bus into register A
                register_a_out => register_a_out,
                -- From register A into bus
                register_a_in => register_a_in,
                -- From bus into register B
                register_b_out => register_b_out,
                -- From bus into register OUTPUT
                register_output_out => register_output_out,
                -- Set program counter to program counter register
                jump => jump,
                -- Advance program counter
                program_counter_advance => program_counter_advance,
                -- From bus into program counter
                program_counter_out => program_counter_out,
                -- From program counter into bus
                program_counter_in => program_counter_in,
                -- From alu into bus
                alu_in => alu_in
    );

registered_alu_instance : registered_alu 
    Generic map (bit_size => bit_size)
    Port map (
    -- Register part
        clk => clk,
        reset => reset,
        load_a => register_a_out,
        register_a => local_bus,
        register_a_out => data_from_register_a,
        load_b => register_b_out,
        register_b => local_bus,
    -- Alu part
        substraction => alu_substraction,
        flag_zero => alu_flag_zero,
        flag_carry => alu_flag_carry,
        output => data_from_alu
    );

registered_program_counter_instance : registered_program_counter
    Generic map (bit_size => bit_size )
    Port map (
    -- Register part
        clk => clk,
        load => program_counter_out,
        data_in => local_bus,
    -- Program counter part
        enable => program_counter_advance,
        set => jump,
        reset => reset,
        out_counter => data_from_program_counter
    );

registered_main_memory_instance : registered_main_memory
    Generic map (bit_size => bit_size)
    Port map (
    -- Register part
        clk => clk,
        reset => reset,
        load => ram_address,
        data_in => local_bus,
    -- Main memory part
        wea => (0 => ram_write),
        douta => data_from_main_memory
    );
    
register_output_instance : register_unit 
    Generic map(bit_size => bit_size)
    Port map (
        clk => clk,
        reset => reset,
        load => register_output_out,
        data_in => local_bus,
        data_out => data_from_register_out
    );
output <= data_from_register_out;

-- Set the value of the bus to the appropiate input
-- Set to 0 if no input is given,
local_bus <= data_from_program_counter when program_counter_in = '1' else
            data_from_main_memory when ram_in = '1' else
            data_from_register_a when register_a_in = '1' else
            data_from_control_unit when register_instruction_in = '1' else
            data_from_alu when alu_in = '1' else
            (others => '0');

end Behavioral;
