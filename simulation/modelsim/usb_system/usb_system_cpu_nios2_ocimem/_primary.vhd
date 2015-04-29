library verilog;
use verilog.vl_types.all;
entity usb_system_cpu_nios2_ocimem is
    port(
        address         : in     vl_logic_vector(8 downto 0);
        byteenable      : in     vl_logic_vector(3 downto 0);
        clk             : in     vl_logic;
        debugaccess     : in     vl_logic;
        jdo             : in     vl_logic_vector(37 downto 0);
        jrst_n          : in     vl_logic;
        read            : in     vl_logic;
        reset_req       : in     vl_logic;
        take_action_ocimem_a: in     vl_logic;
        take_action_ocimem_b: in     vl_logic;
        take_no_action_ocimem_a: in     vl_logic;
        write           : in     vl_logic;
        writedata       : in     vl_logic_vector(31 downto 0);
        MonDReg         : out    vl_logic_vector(31 downto 0);
        ociram_readdata : out    vl_logic_vector(31 downto 0);
        waitrequest     : out    vl_logic
    );
end usb_system_cpu_nios2_ocimem;
