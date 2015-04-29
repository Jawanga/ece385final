library verilog;
use verilog.vl_types.all;
entity usb_system_cpu_nios2_oci_td_mode is
    port(
        ctrl            : in     vl_logic_vector(8 downto 0);
        td_mode         : out    vl_logic_vector(3 downto 0)
    );
end usb_system_cpu_nios2_oci_td_mode;
