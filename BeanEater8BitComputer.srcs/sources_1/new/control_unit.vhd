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
        reset : in std_logic;
        instruction : in std_logic_vector(constants.bit_width -1 downto 0);
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
end control_unit;

architecture Behavioral of control_unit is
    -- This will hold all internal control signals in a single object
    type internal_control_array is
        record
        -- Next instruction
        next_instruction : std_logic;
    end record;
    -- To transfer the internal state to the outputs
    signal internal_control : internal_control_array;
    
    -- This will hold all output control signals in a single object
    type external_control_array is
        record
        -- CPU Control
            soft_reset : std_logic;
            halt : std_logic;
            -- Set the ALU to substraction mode
            alu_substraction : std_logic;
        -- BUS transfer signals
            -- From ram into the bus
            ram_in : std_logic;
            -- From bus into ram
            ram_write : std_logic;
            -- From bus into ram address
            ram_address : std_logic;
            -- From instruction register into bus
            register_instruction_in : std_logic;
            -- From bus into instruction register
            register_instruction_out : std_logic;
            -- From bus into register A
            register_a_out : std_logic;
            -- From register A into bus
            register_a_in : std_logic;
            -- From bus into register B
            register_b_out : std_logic;
            -- From bus into register OUTPUT
            register_output_out : std_logic;
            -- Set program counter to program counter register
            jump : std_logic;
            -- Advance program counter
            program_counter_advance : std_logic;
            -- From bus into program counter
            program_counter_out : std_logic;
            -- From program counter into bus
            program_counter_in : std_logic;
            -- From alu into bus
            alu_in : std_logic;
    end record;
    -- To transfer the internal state to the outputs
    signal external_control : external_control_array;
    
    -- For all control signal representation
    type control_array is 
        record
        -- Internal Control
        internal : internal_control_array;
        external : external_control_array;
    end record;
    
-- Common intruction definitions ----------------------------------------------
    constant common_operation_count : integer := 2;
    -- Common instruction states
    type type_common_instruction_control is 
        array (0 to common_operation_count-1) of control_array;
    -- Common instruction states definitions
    constant common_instruction_control : type_common_instruction_control :=
        (
            -- First common step, load program counter to ram address.
            0 => (
                internal => (
                    others => '0'
                ),
                external => (
                    program_counter_in => '1',
                    ram_address => '1',
                    others => '0'
                )
            ),
            -- Second common step, load from ram next CPU instruction
            1 => (
                internal => (
                    others => '0'
                ),
                external => (
                    ram_in => '1',
                    register_instruction_out => '1',
                    program_counter_advance => '1',
                    others => '0'
                )
            )
        );
        
    -- Single instruction states
    constant max_steps : integer := 3;
    type type_instruction_control is 
        array (0 to max_steps-1) of control_array;
        
-- Single instruction definitions ---------------------------------------------
    -- NO OP Instruction
    constant noop_value : integer := 0;
    constant noop_instruction_control : type_instruction_control :=
        (
            --Step 0
            0 => (
                internal => (
                    next_instruction => '1'
                ),
                external => (
                    others => '0'
                )
            ),
            -- Remianing states set to 0, not allowing any not defined operations
            others => ( internal => (others => '0'), external => (others => '0'))
        );
    -- HALT Instruction
    constant halt_value : integer := 15;
    constant halt_instruction_control : type_instruction_control :=
        (
            --Step 0
            0 => (
                internal => (
                    others => '0'
                ),
                external => (
                    halt => '1',
                    others => '0'
                )
            ),
            -- Remianing states set to 0, not allowing any not defined operations
            others => ( internal => (others => '0'), external => (others => '0'))
        );
    -- LDA Instruction
    constant lda_value : integer := 1;
    constant lda_instruction_control : type_instruction_control :=
        (
            --Step 0
            0 => (
                internal => (
                    others => '0'
                ),
                external => (
                    register_instruction_in => '1',
                    ram_address => '1',
                    others => '0'
                )
            ),
            --Step 1
            1 => (
                internal => (
                    next_instruction => '1'
                ),
                external => (
                    ram_in => '1',
                    register_a_out => '1',
                    others => '0'
                )
            ),
            -- Remianing states set to 0, not allowing any not defined operations
            others => ( internal => (others => '0'), external => (others => '0'))
        );
    
    -- ADD Instruction
    constant ADD_value : integer := 2;
    constant ADD_instruction_control : type_instruction_control :=
        (
            --Step 0
            0 => (
                internal => (
                    others => '0'
                ),
                external => (
                    register_instruction_in => '1',
                    ram_address => '1',
                    others => '0'
                )
            ),
            --Step 1
            1 => (
                internal => (
                    others => '0'
                ),
                external => (
                    ram_in => '1',
                    register_b_out => '1',
                    others => '0'
                )
            ),
            --Step 2
            2 => (
                internal => (
                    next_instruction => '1'
                ),
                external => (
                    alu_in => '1',
                    register_a_out => '1',
                    others => '0'
                )
            )
        );
    
    -- OUT Instruction
    constant OUT_value : integer := 3;
    constant OUT_instruction_control : type_instruction_control :=
        (
            --Step 0
            0 => (
                internal => (
                    next_instruction => '1'
                ),
                external => (
                    register_a_in => '1',
                    register_output_out => '1',
                    others => '0'
                )
            ),
            -- Remianing states set to 0, not allowing any not defined operations
            others => ( internal => (others => '0'), external => (others => '0'))
        );
        
    -- All instruction control array
    type type_all_instruction_control is 
        array (0 to constants.instruction_count-1) of type_instruction_control;

-- Instruction value to its control logic mapping -----------------------------
    constant all_instruction_control : type_all_instruction_control :=
        (
            -- NO OP
            noop_value => (
                noop_instruction_control
            ),
            -- LDA
            lda_value => (
                lda_instruction_control
            ),
            -- ADD
            add_value => (
                add_instruction_control
            ),
            -- OUT
            out_value => (
                out_instruction_control
            ),
            -- HALT
            halt_value => (
                halt_instruction_control
            ),
            -- ALL NOT DEFINED INSTRUCTIONS SHALL NEVER DO ANY OPERATION
            others => (
                others => ( internal => (others => '0'), external => (others => '0'))
            )
        );
        
    signal dbg_instruction_counter : integer := 0;
    signal dbg_instruction_operation : integer := 0;
begin
-- Internal Control
    intruction_data(constants.bit_width -1 downto constants.bit_width - constants.instruction_width)
        <= (others => '0');
    intruction_data(constants.bit_width - constants.instruction_width -1  downto 0)
        <= instruction(constants.bit_width - constants.instruction_width -1  downto 0);
-- CPU Control
    soft_reset <= external_control.soft_reset;
    halt <= external_control.halt;
    alu_substraction <= external_control.alu_substraction;
-- BUS <= output_control.BUS;
    ram_in <= external_control.ram_in;
    ram_write <= external_control.ram_write;
    ram_address <= external_control.ram_address;
    register_instruction_in <= external_control.register_instruction_in;
    register_instruction_out <= external_control.register_instruction_out;
    register_a_out <= external_control.register_a_out;
    register_a_in <= external_control.register_a_in;
    register_b_out <= external_control.register_b_out;
    register_output_out <= external_control.register_output_out;
    jump <= external_control.jump;
    program_counter_advance <= external_control.program_counter_advance;
    program_counter_out <= external_control.program_counter_out;
    program_counter_in <= external_control.program_counter_in;
    alu_in <= external_control.alu_in;

process (clk, reset) is
    use ieee.numeric_std.all;
    variable common_counter : integer := 0;
    variable instruction_counter : integer := 0;
    variable instruction_operation : integer := 0;
    variable process_internal_control : internal_control_array;
    variable process_external_control : external_control_array;
begin
    if reset = '1' then
        common_counter := 0;
        instruction_counter := 0;
        process_internal_control := (others => '0');
        process_external_control := (
                soft_reset => '1',
                others => '0'
            );
    elsif rising_edge(clk) then
        -- Normal state machine of control
        if common_counter < common_operation_count then
            process_internal_control := 
                common_instruction_control(common_counter).internal;
            process_external_control := 
                common_instruction_control(common_counter).external;
            common_counter := common_counter + 1;
        elsif instruction_counter < max_steps then
            instruction_operation := 
                to_integer(unsigned(instruction(
                    constants.bit_width -1 downto
                        constants.bit_width - constants.instruction_width
                )));
            process_internal_control := 
                all_instruction_control(instruction_operation)
                    (instruction_counter).internal;
            process_external_control := 
                all_instruction_control(instruction_operation)
                    (instruction_counter).external;
            instruction_counter := instruction_counter + 1;                
        end if;
        -- Next step in instruction control
        if (instruction_counter >= max_steps) 
            or (process_internal_control.next_instruction = '1') 
        then
            common_counter := 0;
            instruction_counter := 0;
        end if;
    end if;
    -- Set outputs
    internal_control <= process_internal_control;
    external_control <= process_external_control;
    dbg_instruction_counter <= instruction_counter;
    dbg_instruction_operation <= instruction_operation;
end process;

end Behavioral;
