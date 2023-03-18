----------------------------------------------------------------------------------
-- Company: MyOwnBoredom
-- Engineer: Gugolple
-- 
-- Create Date: 03/17/2023 04:48:28 PM
-- Design Name: 
-- Module Name: control_unit - Behavioral
-- Project Name: BenEater8BitComputer
-- Description: The module will contain all control signals needed for the
--     workings of the CPU.
--
--     The source material for this part is the video part starting at
--     https://www.youtube.com/watch?v=AwUirxi9eBg
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constants;

entity control_unit is
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
end control_unit;

architecture Behavioral of control_unit is
begin

process (clk) is
begin

end process;

end Behavioral;
