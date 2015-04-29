library verilog;
use verilog.vl_types.all;
entity block_SM is
    port(
        Clk             : in     vl_logic;
        Reset           : in     vl_logic;
        block_ready     : out    vl_logic_vector(2 downto 0)
    );
end block_SM;
