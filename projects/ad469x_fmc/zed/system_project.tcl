
source ../../scripts/adi_env.tcl
source ../../scripts/adi_project_xilinx.tcl
source ../../scripts/adi_board.tcl

adi_project ad4696_fmc_zed

adi_project_files ad4696_fmc_zed [list \
    "../../../library/xilinx/common/ad_iobuf.v" \
	"../../../library/common/ad_edge_detect.v" \
	"../../../library/util_cdc/sync_bits.v" \
    "../../common/zed/zed_system_constr.xdc" \
	"system_top.v" \
    "system_constr.xdc" \
	]

adi_project_run ad4696_fmc_zed
