library verilog;
use verilog.vl_types.all;
entity altera_avalon_st_clock_crosser is
    generic(
        SYMBOLS_PER_BEAT: integer := 1;
        BITS_PER_SYMBOL : integer := 8;
        FORWARD_SYNC_DEPTH: integer := 2;
        BACKWARD_SYNC_DEPTH: integer := 2;
        USE_OUTPUT_PIPELINE: integer := 1
    );
    port(
        in_clk          : in     vl_logic;
        in_reset        : in     vl_logic;
        in_ready        : out    vl_logic;
        in_valid        : in     vl_logic;
        in_data         : in     vl_logic_vector;
        out_clk         : in     vl_logic;
        out_reset       : in     vl_logic;
        out_ready       : in     vl_logic;
        out_valid       : out    vl_logic;
        out_data        : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of SYMBOLS_PER_BEAT : constant is 1;
    attribute mti_svvh_generic_type of BITS_PER_SYMBOL : constant is 1;
    attribute mti_svvh_generic_type of FORWARD_SYNC_DEPTH : constant is 1;
    attribute mti_svvh_generic_type of BACKWARD_SYNC_DEPTH : constant is 1;
    attribute mti_svvh_generic_type of USE_OUTPUT_PIPELINE : constant is 1;
end altera_avalon_st_clock_crosser;
