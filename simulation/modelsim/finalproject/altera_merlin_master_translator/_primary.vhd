library verilog;
use verilog.vl_types.all;
entity altera_merlin_master_translator is
    generic(
        AV_ADDRESS_W    : integer := 32;
        AV_DATA_W       : integer := 32;
        AV_BURSTCOUNT_W : integer := 4;
        AV_BYTEENABLE_W : integer := 4;
        USE_BURSTCOUNT  : integer := 1;
        USE_BEGINBURSTTRANSFER: integer := 0;
        USE_BEGINTRANSFER: integer := 0;
        USE_CHIPSELECT  : integer := 0;
        USE_READ        : integer := 1;
        USE_READDATAVALID: integer := 1;
        USE_WRITE       : integer := 1;
        USE_WAITREQUEST : integer := 1;
        USE_WRITERESPONSE: integer := 0;
        USE_READRESPONSE: integer := 0;
        AV_REGISTERINCOMINGSIGNALS: integer := 0;
        AV_SYMBOLS_PER_WORD: integer := 4;
        AV_ADDRESS_SYMBOLS: integer := 0;
        AV_CONSTANT_BURST_BEHAVIOR: integer := 1;
        AV_BURSTCOUNT_SYMBOLS: integer := 0;
        AV_LINEWRAPBURSTS: integer := 0;
        UAV_ADDRESS_W   : integer := 38;
        UAV_BURSTCOUNT_W: integer := 10;
        UAV_CONSTANT_BURST_BEHAVIOR: integer := 0
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        uav_write       : out    vl_logic;
        uav_read        : out    vl_logic;
        uav_address     : out    vl_logic_vector;
        uav_burstcount  : out    vl_logic_vector;
        uav_byteenable  : out    vl_logic_vector;
        uav_writedata   : out    vl_logic_vector;
        uav_lock        : out    vl_logic;
        uav_debugaccess : out    vl_logic;
        uav_clken       : out    vl_logic;
        uav_readdata    : in     vl_logic_vector;
        uav_readdatavalid: in     vl_logic;
        uav_waitrequest : in     vl_logic;
        uav_response    : in     vl_logic_vector(1 downto 0);
        uav_writeresponsevalid: in     vl_logic;
        av_write        : in     vl_logic;
        av_read         : in     vl_logic;
        av_address      : in     vl_logic_vector;
        av_byteenable   : in     vl_logic_vector;
        av_burstcount   : in     vl_logic_vector;
        av_writedata    : in     vl_logic_vector;
        av_begintransfer: in     vl_logic;
        av_beginbursttransfer: in     vl_logic;
        av_lock         : in     vl_logic;
        av_chipselect   : in     vl_logic;
        av_debugaccess  : in     vl_logic;
        av_clken        : in     vl_logic;
        av_readdata     : out    vl_logic_vector;
        av_readdatavalid: out    vl_logic;
        av_waitrequest  : out    vl_logic;
        av_response     : out    vl_logic_vector(1 downto 0);
        av_writeresponsevalid: out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of AV_ADDRESS_W : constant is 1;
    attribute mti_svvh_generic_type of AV_DATA_W : constant is 1;
    attribute mti_svvh_generic_type of AV_BURSTCOUNT_W : constant is 1;
    attribute mti_svvh_generic_type of AV_BYTEENABLE_W : constant is 1;
    attribute mti_svvh_generic_type of USE_BURSTCOUNT : constant is 1;
    attribute mti_svvh_generic_type of USE_BEGINBURSTTRANSFER : constant is 1;
    attribute mti_svvh_generic_type of USE_BEGINTRANSFER : constant is 1;
    attribute mti_svvh_generic_type of USE_CHIPSELECT : constant is 1;
    attribute mti_svvh_generic_type of USE_READ : constant is 1;
    attribute mti_svvh_generic_type of USE_READDATAVALID : constant is 1;
    attribute mti_svvh_generic_type of USE_WRITE : constant is 1;
    attribute mti_svvh_generic_type of USE_WAITREQUEST : constant is 1;
    attribute mti_svvh_generic_type of USE_WRITERESPONSE : constant is 1;
    attribute mti_svvh_generic_type of USE_READRESPONSE : constant is 1;
    attribute mti_svvh_generic_type of AV_REGISTERINCOMINGSIGNALS : constant is 1;
    attribute mti_svvh_generic_type of AV_SYMBOLS_PER_WORD : constant is 1;
    attribute mti_svvh_generic_type of AV_ADDRESS_SYMBOLS : constant is 1;
    attribute mti_svvh_generic_type of AV_CONSTANT_BURST_BEHAVIOR : constant is 1;
    attribute mti_svvh_generic_type of AV_BURSTCOUNT_SYMBOLS : constant is 1;
    attribute mti_svvh_generic_type of AV_LINEWRAPBURSTS : constant is 1;
    attribute mti_svvh_generic_type of UAV_ADDRESS_W : constant is 1;
    attribute mti_svvh_generic_type of UAV_BURSTCOUNT_W : constant is 1;
    attribute mti_svvh_generic_type of UAV_CONSTANT_BURST_BEHAVIOR : constant is 1;
end altera_merlin_master_translator;
