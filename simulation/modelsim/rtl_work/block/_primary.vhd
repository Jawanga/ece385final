library verilog;
use verilog.vl_types.all;
entity \block\ is
    generic(
        Block_X_Min     : vl_logic_vector(9 downto 0) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        Block_X_Max     : vl_logic_vector(9 downto 0) := (Hi1, Hi0, Hi0, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1);
        Block_Y_Min     : vl_logic_vector(9 downto 0) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        Block_Y_Max     : vl_logic_vector(9 downto 0) := (Hi0, Hi1, Hi1, Hi1, Hi0, Hi1, Hi1, Hi1, Hi1, Hi1);
        Block_X_Step    : vl_logic_vector(9 downto 0) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1);
        Block_Y_Step    : vl_logic_vector(9 downto 0) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1)
    );
    port(
        Reset           : in     vl_logic;
        frame_clk       : in     vl_logic;
        Block_X_Center  : in     vl_logic_vector(9 downto 0);
        BlockX          : out    vl_logic_vector(9 downto 0);
        BlockY          : out    vl_logic_vector(9 downto 0);
        BlockS          : out    vl_logic_vector(9 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Block_X_Min : constant is 2;
    attribute mti_svvh_generic_type of Block_X_Max : constant is 2;
    attribute mti_svvh_generic_type of Block_Y_Min : constant is 2;
    attribute mti_svvh_generic_type of Block_Y_Max : constant is 2;
    attribute mti_svvh_generic_type of Block_X_Step : constant is 2;
    attribute mti_svvh_generic_type of Block_Y_Step : constant is 2;
end \block\;
