----------------------------------------------------------------------------------
-- Company: MyOwnBoredom
-- Engineer: Gugolple
-- 
-- Create Date: 03/17/2023 04:48:28 PM
-- Design Name: 
-- Module Name: control_unit - Behavioral
-- Project Name: BenEater8BitComputer
-- Description: The control unit will manage all IO needed for the CPU to work.
--     Due to FPGA not having a tri-state bus, all buses are required to have
--     an AND operation with their enable signal, and all of the buses be OR
--     togeather as the input.
--
--     This element will contain all others, as being the main unit and handle
--     the enabling of modules.
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
--  Port ( );
end control_unit;

architecture Behavioral of control_unit is
-- Main CPU signals
    signal reset : std_logic := '0';
    signal halt : std_logic := '0';

-- BUS transfer signals
    -- In the video is said as "memory in"
    signal rom_enable : std_logic := '0';
    -- From ram into the bus
    signal ram_in : std_logic := '0';
    -- From bus into the ram
    signal ram_out : std_logic := '0';
    -- From bus into register A
    signal register_a_in : std_logic := '0';
    -- From bus into register B
    signal register_b_in : std_logic := '0';
    -- From bus into register OUTPUT
    signal register_output_in : std_logic := '0';
    -- From bus into program counter
    signal program_counter_in : std_logic := '0';
    -- From program counter into bus
    signal program_counter_out : std_logic := '0';
    -- From alu into bus
    signal alu_in : std_logic := '0';

-- CPU control signals
    -- Set the ALU to substraction mode
    signal alu_substraction : std_logic := '0';
    -- Set program counter register to program counter
    signal jump : std_logic := '0';
    
-- OUTPUT register
    -- Output display register, to mimic what its seen in video
    signal output_register : std_logic_vector(constants.bit_width -1 downto 0);
begin


end Behavioral;
