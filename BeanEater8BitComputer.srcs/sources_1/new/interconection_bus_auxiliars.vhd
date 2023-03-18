----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2023 01:47:24 PM
-- Design Name: 
-- Module Name: interconection_bus_auxiliars - Behavioral
-- Project Name: BenEater8BitComputer
-- Description: This module will handle all extra registers and special
--     functionality for expected behaviour of the units.
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

-- Program counter auxiliar register ------------------------------------------
-- This will add a register to maintain the next value to jump to.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.constants;

entity registered_program_counter is
    Generic(
        bit_size : integer := constants.bit_width 
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
end registered_program_counter;

architecture Behavioral of registered_program_counter is
-- Register unit reference
component register_unit is
  Generic(
    bit_size : integer := bit_size
  );
  Port (
    clk : in std_logic;
    load : in std_logic;
    data_in : in std_logic_vector(bit_size -1 downto 0);
    data_out : out std_logic_vector(bit_size -1 downto 0)
  );
end component;

-- Program counter reference
component program_counter is
    Generic(
        bit_size : integer := bit_size 
    );
    Port (
        clk : in std_logic;
        enable : in std_logic;
        set : in std_logic;
        reset : in std_logic;
        in_counter : in std_logic_vector(bit_size -1 downto 0);
        out_counter : out std_logic_vector(bit_size -1 downto 0)
    );
end component;

-- Internal signals
    signal internal_data_bus : std_logic_vector(bit_size -1 downto 0);
begin

-- Instanciation
register_unit_instance : register_unit 
    Generic map (bit_size => bit_size)
    Port map(
        clk => clk,
        load => load,
        data_in => data_in,
        data_out => internal_data_bus
    );
program_counter_instance : program_counter 
    Generic map (bit_size => bit_size)
    Port map(
        clk => clk,
        set => set,
        enable => enable,
        reset => reset,
        in_counter => internal_data_bus,
        out_counter => out_counter
    );
end Behavioral;


-- Main memory auxiliar register ----------------------------------------------
-- This will add a register to keep the address latched.
-- When load is high the value of data_in will be kept in a register, that will
--     set the data address for the memory.
-- When wea is high the value of data in will be stored in the previously set
--     memory address.
-- douta will always contain the current address memory output.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.constants;

entity registered_main_memory is
    Generic(
        bit_size : integer := constants.bit_width 
    );
    Port(
    -- Register part
        clk : in std_logic;
        load : in std_logic;
        data_in : in std_logic_vector(bit_size -1 downto 0);
    -- Main memory part
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
end registered_main_memory;

architecture Behavioral of registered_main_memory is
-- Register unit reference
component register_unit is
  Generic(
    bit_size : integer := bit_size
  );
  Port (
    clk : in std_logic;
    load : in std_logic;
    data_in : in std_logic_vector(bit_size -1 downto 0);
    data_out : out std_logic_vector(bit_size -1 downto 0)
  );
end component;
-- Main memory reference
component main_memory is
  Port (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
end component;

-- Internal signals
    signal internal_data_bus : std_logic_vector(bit_size -1 downto 0);
begin
register_unit_instance : register_unit 
    Generic map (bit_size => bit_size)
    Port map(
        clk => clk,
        load => load,
        data_in => data_in,
        data_out => internal_data_bus
    );
    
main_memory_instance : main_memory 
    Port map(
        clka => clk,
        wea => wea,
        addra => internal_data_bus,
        dina => data_in,
        douta => douta
    );
end Behavioral;




-- Control unit auxiliar register ---------------------------------------------
-- This will add a register to keep the current instruction.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.constants;

entity registered_control_unit is
    Generic(
        bit_size : integer := constants.bit_width 
    );
    Port(
    -- Register part
        clk : in std_logic;
        load : in std_logic;
        data_in : in std_logic_vector(bit_size -1 downto 0);
    -- Control unit part
        -- Input signals
            -- CPU control signals
                -- Get alu flags for flow control
                alu_flag_zero : in std_logic;
                alu_flag_carry : in std_logic;
        -- Output signals
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
end registered_control_unit;

architecture Behavioral of registered_control_unit is
-- Register unit reference
component register_unit is
  Generic(
    bit_size : integer := bit_size
  );
  Port (
    clk : in std_logic;
    load : in std_logic;
    data_in : in std_logic_vector(bit_size -1 downto 0);
    data_out : out std_logic_vector(bit_size -1 downto 0)
  );
end component;
-- Control unit reference
component control_unit is
    Port (
    -- Input signals
        clk : in std_logic;
        instruction : in std_logic_vector(constants.bit_width -1 downto 0);
        -- CPU control signals
            -- Get alu flags for flow control
            alu_flag_zero : in std_logic;
            alu_flag_carry : in std_logic;
    -- Output signals
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

-- Internal signals
    signal internal_data_bus : std_logic_vector(bit_size -1 downto 0);
begin

register_unit_instance : register_unit 
    Generic map (bit_size => bit_size)
    Port map(
        clk => clk,
        load => load,
        data_in => data_in,
        data_out => internal_data_bus
    );
    
control_unit_instance : control_unit 
    Port map(
    -- Input signals
        clk => clk,
        instruction => internal_data_bus,
        -- CPU control signals
            -- Get alu flags for flow control
            alu_flag_zero => alu_flag_zero,
            alu_flag_carry => alu_flag_carry,
    -- Output signals
        -- Main CPU signals
            soft_reset => soft_reset,
            halt => halt,
            -- Set the ALU to substraction mode
            alu_substraction => alu_substraction,
        -- BUS transfer signals
            -- From ram into the bus
            ram_in => ram_in,
            -- From bus into ram
            ram_write => ram_write,
            -- From bus into ram address
            ram_address => ram_address,
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

end Behavioral;


-- Alu auxiliar register ------------------------------------------------------
-- This will add a register A and B for the ALU.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.constants;

entity registered_alu is
    Generic(
        bit_size : integer := constants.bit_width 
    );
    Port(
    -- Register part
        clk : in std_logic;
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
end registered_alu;

architecture Behavioral of registered_alu is
-- Register unit reference
component register_unit is
  Generic(
    bit_size : integer := bit_size
  );
  Port (
    clk : in std_logic;
    load : in std_logic;
    data_in : in std_logic_vector(bit_size -1 downto 0);
    data_out : out std_logic_vector(bit_size -1 downto 0)
  );
end component;
-- Alu reference
component alu is
  Port (
        substraction : in std_logic;
        a_in : in std_logic_vector(constants.bit_width -1 downto 0);
        b_in : in std_logic_vector(constants.bit_width -1 downto 0);
        flag_zero : out std_logic;
        flag_carry : out std_logic;
        output : inout std_logic_vector(constants.bit_width -1 downto 0)
  );
end component;

-- Internal signals
    signal internal_data_a: std_logic_vector(bit_size -1 downto 0);
    signal internal_data_b: std_logic_vector(bit_size -1 downto 0);
begin
register_unit_a_instance : register_unit 
    Generic map (bit_size => bit_size)
    Port map(
        clk => clk,
        load => load_a,
        data_in => register_a,
        data_out => internal_data_a
    );

register_unit_b_instance : register_unit 
    Generic map (bit_size => bit_size)
    Port map(
        clk => clk,
        load => load_b,
        data_in => register_b,
        data_out => internal_data_b
    );
    
alu_instance : alu 
    Port map(
        substraction => substraction,
        a_in => internal_data_a,
        b_in => internal_data_b,
        flag_zero => flag_zero,
        flag_carry => flag_carry,
        output => output
    );
    
register_a_out <= internal_data_a;
end Behavioral;
