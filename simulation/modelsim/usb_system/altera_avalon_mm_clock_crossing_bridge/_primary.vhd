library verilog;
use verilog.vl_types.all;
entity altera_avalon_mm_clock_crossing_bridge is
    generic(
        DATA_WIDTH      : integer := 32;
        SYMBOL_WIDTH    : integer := 8;
        HDL_ADDR_WIDTH  : integer := 10;
        BURSTCOUNT_WIDTH: integer := 1;
        COMMAND_FIFO_DEPTH: integer := 4;
        RESPONSE_FIFO_DEPTH: integer := 4;
        MASTER_SYNC_DEPTH: integer := 2;
        SLAVE_SYNC_DEPTH: integer := 2;
        BYTEEN_WIDTH    : vl_notype
    );
    port(
        s0_clk          : in     vl_logic;
        s0_reset        : in     vl_logic;
        m0_clk          : in     vl_logic;
        m0_reset        : in     vl_logic;
        s0_waitrequest  : out    vl_logic;
        s0_readdata     : out    vl_logic_vector;
        s0_readdatavalid: out    vl_logic;
        s0_burstcount   : in     vl_logic_vector;
        s0_writedata    : in     vl_logic_vector;
        s0_address      : in     vl_logic_vector;
        s0_write        : in     vl_logic;
        s0_read         : in     vl_logic;
        s0_byteenable   : in     vl_logic_vector;
        s0_debugaccess  : in     vl_logic;
        m0_waitrequest  : in     vl_logic;
        m0_readdata     : in     vl_logic_vector;
        m0_readdatavalid: in     vl_logic;
        m0_burstcount   : out    vl_logic_vector;
        m0_writedata    : out    vl_logic_vector;
        m0_address      : out    vl_logic_vector;
        m0_write        : out    vl_logic;
        m0_read         : out    vl_logic;
        m0_byteenable   : out    vl_logic_vector;
        m0_debugaccess  : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of SYMBOL_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of HDL_ADDR_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of BURSTCOUNT_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of COMMAND_FIFO_DEPTH : constant is 1;
    attribute mti_svvh_generic_type of RESPONSE_FIFO_DEPTH : constant is 1;
    attribute mti_svvh_generic_type of MASTER_SYNC_DEPTH : constant is 1;
    attribute mti_svvh_generic_type of SLAVE_SYNC_DEPTH : constant is 1;
    attribute mti_svvh_generic_type of BYTEEN_WIDTH : constant is 3;
end altera_avalon_mm_clock_crossing_bridge;
