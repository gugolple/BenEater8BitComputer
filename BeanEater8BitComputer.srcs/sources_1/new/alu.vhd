----------------------------------------------------------------------------------
-- Company: None
-- Engineer: Gugolple
-- 
-- Create Date: 03/15/2023 04:55:16 PM
-- Module Name: alu - Behavioral
-- Project Name: BenEater8BitComputer
-- Description: This module will be an aproximation of the alu from the
--     video https://www.youtube.com/watch?v=mOVOS9AjgFs.
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.constants;
use work.full_adder;

entity alu is
    Port ( 
        substraction : in std_logic;
        register_a_in : in std_logic_vector(constants.bit_width -1 downto 0);
        register_b_in : in std_logic_vector(constants.bit_width -1 downto 0);
        flag_zero : out std_logic;
        flag_carry : out std_logic;
        output : inout std_logic_vector(constants.bit_width -1 downto 0)
    );
end alu;


architecture Behavioral of alu is
-- We import the full adder
component full_adder is
    Port (
        bit_a : in std_logic;
        bit_b : in std_logic;
        bit_carry : in std_logic;
        output_bit : out std_logic;
        output_carry : out std_logic
    );
end component;
-- We use a carry vector to handle the chain carry
signal adder_carry_vector : std_logic_vector(constants.bit_width downto 0);

-- Local mirror of register b for local operation
signal register_b_used : std_logic_vector(constants.bit_width -1 downto 0);

begin
-- Generation of component to XOR the B register with the NEGATE_REGISTER_FLAG
-- for substraction operations.
xor_of_register_b: for i in 0 to constants.bit_width -1 generate
    register_b_used(i) <= register_b_in(i) xor substraction;
end generate;

-- For addition we set first value of carry vector to the NEGATE_REGISTER_FLAG
adder_carry_vector(0) <= substraction;
-- We generate all the chain adders
adder_of_register_a_b: for i in 0 to constants.bit_width -1 generate
    current_adder: full_adder port map (
        -- For register A is taken as is.
        bit_a => register_a_in(i),
        -- For register B is used the local mirror
        bit_b => register_b_used(i),
        -- The carry chain is as expected
        bit_carry => adder_carry_vector(i),
        -- We output the result of the addition directly to output
        output_bit => output(i),
        -- We output the resutlt of the carry chain to the next bit
        output_carry => adder_carry_vector(i+1)
    );
 -- The last value of the carry chain contains if the operation has resulted in
 -- carry.
 flag_carry <= adder_carry_vector(constants.bit_width);
 
 -- For the zero flag we generate and adder 
 flag_zero <= not(or(output));

end generate;




end Behavioral;
