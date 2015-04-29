library verilog;
use verilog.vl_types.all;
entity usb_system_cpu_nios2_oci is
    port(
        D_valid         : in     vl_logic;
        E_st_data       : in     vl_logic_vector(31 downto 0);
        E_valid         : in     vl_logic;
        F_pc            : in     vl_logic_vector(26 downto 0);
        address_nxt     : in     vl_logic_vector(8 downto 0);
        av_ld_data_aligned_filtered: in     vl_logic_vector(31 downto 0);
        byteenable_nxt  : in     vl_logic_vector(3 downto 0);
        clk             : in     vl_logic;
        d_address       : in     vl_logic_vector(28 downto 0);
        d_read          : in     vl_logic;
        d_waitrequest   : in     vl_logic;
        d_write         : in     vl_logic;
        debugaccess_nxt : in     vl_logic;
        hbreak_enabled  : in     vl_logic;
        read_nxt        : in     vl_logic;
        reset           : in     vl_logic;
        reset_n         : in     vl_logic;
        reset_req       : in     vl_logic;
        test_ending     : in     vl_logic;
        test_has_ended  : in     vl_logic;
        write_nxt       : in     vl_logic;
        writedata_nxt   : in     vl_logic_vector(31 downto 0);
        jtag_debug_module_debugaccess_to_roms: out    vl_logic;
        oci_hbreak_req  : out    vl_logic;
        oci_ienable     : out    vl_logic_vector(31 downto 0);
        oci_single_step_mode: out    vl_logic;
        readdata        : out    vl_logic_vector(31 downto 0);
        resetrequest    : out    vl_logic;
        waitrequest     : out    vl_logic
    );
end usb_system_cpu_nios2_oci;
