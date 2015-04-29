library verilog;
use verilog.vl_types.all;
entity usb_system_cpu_nios2_oci_fifo_wrptr_inc is
    port(
        ge2_free        : in     vl_logic;
        ge3_free        : in     vl_logic;
        input_tm_cnt    : in     vl_logic_vector(1 downto 0);
        fifo_wrptr_inc  : out    vl_logic_vector(3 downto 0)
    );
end usb_system_cpu_nios2_oci_fifo_wrptr_inc;
