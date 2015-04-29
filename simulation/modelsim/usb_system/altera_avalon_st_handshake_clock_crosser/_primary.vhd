library verilog;
use verilog.vl_types.all;
entity altera_avalon_st_handshake_clock_crosser is
    generic(
        DATA_WIDTH      : integer := 8;
        BITS_PER_SYMBOL : integer := 8;
        USE_PACKETS     : integer := 0;
        USE_CHANNEL     : integer := 0;
        CHANNEL_WIDTH   : integer := 1;
        USE_ERROR       : integer := 0;
        ERROR_WIDTH     : integer := 1;
        VALID_SYNC_DEPTH: integer := 2;
        READY_SYNC_DEPTH: integer := 2;
        USE_OUTPUT_PIPELINE: integer := 1;
        SYMBOLS_PER_BEAT: vl_notype;
        EMPTY_WIDTH     : vl_notype
    );
    port(
        in_clk          : in     vl_logic;
        in_reset        : in     vl_logic;
        out_clk         : in     vl_logic;
        out_reset       : in     vl_logic;
        in_ready        : out    vl_logic;
        in_valid        : in     vl_logic;
        in_data         : in     vl_logic_vector;
        in_channel      : in     vl_logic_vector;
        in_error        : in     vl_logic_vector;
        in_startofpacket: in     vl_logic;
        in_endofpacket  : in     vl_logic;
        in_empty        : in     vl_logic_vector;
        out_ready       : in     vl_logic;
        out_valid       : out    vl_logic;
        out_data        : out    vl_logic_vector;
        out_channel     : out    vl_logic_vector;
        out_error       : out    vl_logic_vector;
        out_startofpacket: out    vl_logic;
        out_endofpacket : out    vl_logic;
        out_empty       : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of BITS_PER_SYMBOL : constant is 1;
    attribute mti_svvh_generic_type of USE_PACKETS : constant is 1;
    attribute mti_svvh_generic_type of USE_CHANNEL : constant is 1;
    attribute mti_svvh_generic_type of CHANNEL_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of USE_ERROR : constant is 1;
    attribute mti_svvh_generic_type of ERROR_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of VALID_SYNC_DEPTH : constant is 1;
    attribute mti_svvh_generic_type of READY_SYNC_DEPTH : constant is 1;
    attribute mti_svvh_generic_type of USE_OUTPUT_PIPELINE : constant is 1;
    attribute mti_svvh_generic_type of SYMBOLS_PER_BEAT : constant is 3;
    attribute mti_svvh_generic_type of EMPTY_WIDTH : constant is 3;
end altera_avalon_st_handshake_clock_crosser;
