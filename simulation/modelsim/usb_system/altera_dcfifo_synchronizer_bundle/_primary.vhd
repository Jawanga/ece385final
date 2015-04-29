library verilog;
use verilog.vl_types.all;
entity altera_dcfifo_synchronizer_bundle is
    generic(
        WIDTH           : integer := 1;
        DEPTH           : integer := 3
    );
    port(
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        din             : in     vl_logic_vector;
        dout            : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
    attribute mti_svvh_generic_type of DEPTH : constant is 1;
end altera_dcfifo_synchronizer_bundle;
