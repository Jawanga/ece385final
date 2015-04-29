library verilog;
use verilog.vl_types.all;
entity CY7C67200_IF is
    port(
        iDATA           : in     vl_logic_vector(31 downto 0);
        oDATA           : out    vl_logic_vector(31 downto 0);
        iADDR           : in     vl_logic_vector(1 downto 0);
        iRD_N           : in     vl_logic;
        iWR_N           : in     vl_logic;
        iCS_N           : in     vl_logic;
        iRST_N          : in     vl_logic;
        iCLK            : in     vl_logic;
        oINT            : out    vl_logic;
        HPI_DATA        : inout  vl_logic_vector(15 downto 0);
        HPI_ADDR        : out    vl_logic_vector(1 downto 0);
        HPI_RD_N        : out    vl_logic;
        HPI_WR_N        : out    vl_logic;
        HPI_CS_N        : out    vl_logic;
        HPI_RST_N       : out    vl_logic;
        HPI_INT         : in     vl_logic
    );
end CY7C67200_IF;
