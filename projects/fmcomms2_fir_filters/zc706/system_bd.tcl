

set project_dir [pwd]
cd $ad_hdl_dir/projects/fmcomms2/zc706/
source system_bd.tcl
cd $project_dir


delete_bd_objs [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_pins util_ad9361_dac_upack/dac_valid_*]]]
delete_bd_objs [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_pins util_ad9361_dac_upack/dac_enable_*]]]
delete_bd_objs [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_pins util_ad9361_dac_upack/dac_data_*]]]

delete_bd_objs [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_pins util_ad9361_adc_pack/adc_valid_*]]]
delete_bd_objs [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_pins util_ad9361_adc_pack/adc_enable_*]]]
delete_bd_objs [get_bd_nets -of_objects [find_bd_objs -relation connected_to [get_bd_pins util_ad9361_adc_pack/adc_data_*]]]

ad_ip_instance xlslice interp_slice
ad_ip_instance util_fir_int fir_interpolator_0
ad_ip_instance util_fir_int fir_interpolator_1

ad_ip_instance xlslice decim_slice
ad_ip_instance util_fir_dec fir_decimator_0
ad_ip_instance util_fir_dec fir_decimator_1

ad_ip_instance xlconcat concat_0
ad_ip_parameter concat_0 CONFIG.IN1_WIDTH.VALUE_SRC USER
ad_ip_parameter concat_0 CONFIG.IN0_WIDTH.VALUE_SRC USER
ad_ip_parameter concat_0 CONFIG.IN0_WIDTH 16
ad_ip_parameter concat_0 CONFIG.IN1_WIDTH 16

ad_ip_instance xlconcat concat_1
ad_ip_parameter concat_1 CONFIG.IN1_WIDTH.VALUE_SRC USER
ad_ip_parameter concat_1 CONFIG.IN0_WIDTH.VALUE_SRC USER
ad_ip_parameter concat_1 CONFIG.IN0_WIDTH 16
ad_ip_parameter concat_1 CONFIG.IN1_WIDTH 16

ad_ip_instance xlslice pack0_slice_0
ad_ip_parameter pack0_slice_0 CONFIG.DIN_FROM 15
ad_ip_parameter pack0_slice_0 CONFIG.DIN_TO 0
ad_ip_parameter pack0_slice_0 CONFIG.DOUT_WIDTH 16

ad_ip_instance xlslice pack0_slice_1
ad_ip_parameter pack0_slice_1 CONFIG.DIN_FROM 31
ad_ip_parameter pack0_slice_1 CONFIG.DIN_TO 16
ad_ip_parameter pack0_slice_1 CONFIG.DOUT_WIDTH 16

ad_ip_instance xlslice pack1_slice_0
ad_ip_parameter pack1_slice_0 CONFIG.DIN_FROM 15
ad_ip_parameter pack1_slice_0 CONFIG.DIN_TO 0
ad_ip_parameter pack1_slice_0 CONFIG.DOUT_WIDTH 16

ad_ip_instance xlslice pack1_slice_1
ad_ip_parameter pack1_slice_1 CONFIG.DIN_FROM 31
ad_ip_parameter pack1_slice_1 CONFIG.DIN_TO 16
ad_ip_parameter pack1_slice_1 CONFIG.DOUT_WIDTH 16

# fir interpolator 0
ad_connect clkdiv/clk_out fir_interpolator_0/aclk
ad_connect util_ad9361_dac_upack/dac_enable_0 dac_fifo/din_enable_0
ad_connect util_ad9361_dac_upack/dac_enable_1 dac_fifo/din_enable_1
ad_connect util_ad9361_dac_upack/dac_valid_0 fir_interpolator_0/s_axis_data_tready
ad_connect util_ad9361_dac_upack/dac_valid_1 fir_interpolator_0/s_axis_data_tready
ad_connect util_ad9361_dac_upack/upack_valid_0 fir_interpolator_0/s_axis_data_tvalid
ad_connect dac_fifo/din_data_0 fir_interpolator_0/channel_0
ad_connect dac_fifo/din_data_1 fir_interpolator_0/channel_1
ad_connect dac_fifo/din_valid_0 fir_interpolator_0/dac_read

ad_connect concat_0/In0 util_ad9361_dac_upack/dac_data_0
ad_connect concat_0/In1 util_ad9361_dac_upack/dac_data_1
ad_connect concat_0/dout fir_interpolator_0/s_axis_data_tdata

# fir interpolator 1
ad_connect clkdiv/clk_out fir_interpolator_1/aclk
ad_connect util_ad9361_dac_upack/dac_enable_2 dac_fifo/din_enable_2
ad_connect util_ad9361_dac_upack/dac_enable_3 dac_fifo/din_enable_3
ad_connect util_ad9361_dac_upack/dac_valid_2 fir_interpolator_1/s_axis_data_tready
ad_connect util_ad9361_dac_upack/dac_valid_3 fir_interpolator_1/s_axis_data_tready
ad_connect util_ad9361_dac_upack/upack_valid_2 fir_interpolator_1/s_axis_data_tvalid
ad_connect dac_fifo/din_data_2 fir_interpolator_1/channel_0
ad_connect dac_fifo/din_data_3 fir_interpolator_1/channel_1
ad_connect dac_fifo/din_valid_2 fir_interpolator_1/dac_read

ad_connect concat_1/In0 util_ad9361_dac_upack/dac_data_2
ad_connect concat_1/In1 util_ad9361_dac_upack/dac_data_3
ad_connect concat_1/dout fir_interpolator_1/s_axis_data_tdata

ad_connect util_ad9361_dac_upack/dma_xfer_in VCC

# gpio controlled
ad_connect axi_ad9361/up_dac_gpio_out interp_slice/Din
ad_connect fir_interpolator_0/interpolate interp_slice/Dout
ad_connect fir_interpolator_1/interpolate interp_slice/Dout

# ad_connect axi_ad9361_dac_dma/fifo_rd_en fir_interpolator_1/s_axis_data_tready

# fir decimator 0
ad_connect clkdiv/clk_out fir_decimator_0/aclk
ad_connect util_ad9361_adc_fifo/dout_data_0 fir_decimator_0/channel_0
ad_connect util_ad9361_adc_fifo/dout_data_1 fir_decimator_0/channel_1
ad_connect util_ad9361_adc_fifo/dout_valid_0 fir_decimator_0/s_axis_data_tvalid
ad_connect util_ad9361_adc_pack/adc_valid_0 fir_decimator_0/m_axis_data_tvalid
ad_connect util_ad9361_adc_pack/adc_valid_1 fir_decimator_0/m_axis_data_tvalid
ad_connect util_ad9361_adc_pack/adc_enable_0 util_ad9361_adc_fifo/dout_enable_0
ad_connect util_ad9361_adc_pack/adc_enable_1 util_ad9361_adc_fifo/dout_enable_1
ad_connect pack0_slice_0/Din fir_decimator_0/m_axis_data_tdata
ad_connect pack0_slice_1/Din fir_decimator_0/m_axis_data_tdata
ad_connect util_ad9361_adc_pack/adc_data_0 pack0_slice_0/Dout
ad_connect util_ad9361_adc_pack/adc_data_1 pack0_slice_1/Dout

# fir decimator 1
ad_connect clkdiv/clk_out fir_decimator_1/aclk
ad_connect util_ad9361_adc_fifo/dout_data_2 fir_decimator_1/channel_0
ad_connect util_ad9361_adc_fifo/dout_data_3 fir_decimator_1/channel_1
ad_connect util_ad9361_adc_fifo/dout_valid_2 fir_decimator_1/s_axis_data_tvalid
ad_connect util_ad9361_adc_pack/adc_valid_2 fir_decimator_1/m_axis_data_tvalid
ad_connect util_ad9361_adc_pack/adc_valid_3 fir_decimator_1/m_axis_data_tvalid
ad_connect util_ad9361_adc_pack/adc_enable_2 util_ad9361_adc_fifo/dout_enable_2
ad_connect util_ad9361_adc_pack/adc_enable_3 util_ad9361_adc_fifo/dout_enable_3
ad_connect pack1_slice_0/Din fir_decimator_1/m_axis_data_tdata
ad_connect pack1_slice_1/Din fir_decimator_1/m_axis_data_tdata
ad_connect util_ad9361_adc_pack/adc_data_2 pack1_slice_0/Dout
ad_connect util_ad9361_adc_pack/adc_data_3 pack1_slice_1/Dout

#gpio controlled
ad_connect axi_ad9361/up_adc_gpio_out decim_slice/Din
ad_connect fir_decimator_0/decimate decim_slice/Dout
ad_connect fir_decimator_1/decimate decim_slice/Dout



ad_ip_instance ila ila_FIR_int
ad_ip_parameter ila_FIR_int CONFIG.C_MONITOR_TYPE Native
ad_ip_parameter ila_FIR_int CONFIG.C_NUM_OF_PROBES 12
ad_ip_parameter ila_FIR_int CONFIG.C_TRIGIN_EN false
ad_ip_parameter ila_FIR_int CONFIG.C_PROBE0_WIDTH 16
ad_ip_parameter ila_FIR_int CONFIG.C_PROBE1_WIDTH 16
ad_ip_parameter ila_FIR_int CONFIG.C_PROBE2_WIDTH 32
ad_ip_parameter ila_FIR_int CONFIG.C_PROBE3_WIDTH 1
ad_ip_parameter ila_FIR_int CONFIG.C_PROBE4_WIDTH 1
ad_ip_parameter ila_FIR_int CONFIG.C_PROBE5_WIDTH 1
ad_ip_parameter ila_FIR_int CONFIG.C_PROBE6_WIDTH 16
ad_ip_parameter ila_FIR_int CONFIG.C_PROBE7_WIDTH 16
ad_ip_parameter ila_FIR_int CONFIG.C_PROBE8_WIDTH 32
ad_ip_parameter ila_FIR_int CONFIG.C_PROBE9_WIDTH 1
ad_ip_parameter ila_FIR_int CONFIG.C_PROBE10_WIDTH 1
ad_ip_parameter ila_FIR_int CONFIG.C_PROBE11_WIDTH 1

ad_connect ila_FIR_int/clk clkdiv/clk_out
# interpolator 0
ad_connect ila_FIR_int/probe0 fir_interpolator_0/channel_0
ad_connect ila_FIR_int/probe1 fir_interpolator_0/channel_1
ad_connect ila_FIR_int/probe2 fir_interpolator_0/s_axis_data_tdata
ad_connect ila_FIR_int/probe3 fir_interpolator_0/s_axis_data_tready
ad_connect ila_FIR_int/probe4 fir_interpolator_0/s_axis_data_tvalid
ad_connect ila_FIR_int/probe5 fir_interpolator_0/m_axis_data_tvalid
# interpolator 1
ad_connect ila_FIR_int/probe6 fir_interpolator_1/channel_0
ad_connect ila_FIR_int/probe7 fir_interpolator_1/channel_1
ad_connect ila_FIR_int/probe8 fir_interpolator_1/s_axis_data_tdata
ad_connect ila_FIR_int/probe9 fir_interpolator_1/s_axis_data_tready
ad_connect ila_FIR_int/probe10 fir_interpolator_1/s_axis_data_tvalid
ad_connect ila_FIR_int/probe11 fir_interpolator_1/m_axis_data_tvalid



ad_ip_instance ila ila_dac_fifo
ad_ip_parameter ila_dac_fifo CONFIG.C_MONITOR_TYPE Native
ad_ip_parameter ila_dac_fifo CONFIG.C_NUM_OF_PROBES 16
ad_ip_parameter ila_dac_fifo CONFIG.C_TRIGIN_EN false
ad_ip_parameter ila_dac_fifo CONFIG.C_PROBE0_WIDTH 1
ad_ip_parameter ila_dac_fifo CONFIG.C_PROBE1_WIDTH 1
ad_ip_parameter ila_dac_fifo CONFIG.C_PROBE2_WIDTH 1
ad_ip_parameter ila_dac_fifo CONFIG.C_PROBE3_WIDTH 1
ad_ip_parameter ila_dac_fifo CONFIG.C_PROBE4_WIDTH 1
ad_ip_parameter ila_dac_fifo CONFIG.C_PROBE5_WIDTH 1
ad_ip_parameter ila_dac_fifo CONFIG.C_PROBE6_WIDTH 1
ad_ip_parameter ila_dac_fifo CONFIG.C_PROBE7_WIDTH 1
ad_ip_parameter ila_dac_fifo CONFIG.C_PROBE8_WIDTH 1
ad_ip_parameter ila_dac_fifo CONFIG.C_PROBE9_WIDTH 1
ad_ip_parameter ila_dac_fifo CONFIG.C_PROBE10_WIDTH 1
ad_ip_parameter ila_dac_fifo CONFIG.C_PROBE11_WIDTH 1
ad_ip_parameter ila_dac_fifo CONFIG.C_PROBE12_WIDTH 1
ad_ip_parameter ila_dac_fifo CONFIG.C_PROBE13_WIDTH 1
ad_ip_parameter ila_dac_fifo CONFIG.C_PROBE14_WIDTH 1
ad_ip_parameter ila_dac_fifo CONFIG.C_PROBE15_WIDTH 1

ad_connect ila_dac_fifo/clk clkdiv/clk_out
ad_connect ila_dac_fifo/probe0 dac_fifo/din_valid_0
ad_connect ila_dac_fifo/probe1 dac_fifo/din_valid_1
ad_connect ila_dac_fifo/probe2 dac_fifo/din_valid_2
ad_connect ila_dac_fifo/probe3 dac_fifo/din_valid_3
ad_connect ila_dac_fifo/probe4 dac_fifo/din_enable_0
ad_connect ila_dac_fifo/probe5 dac_fifo/din_enable_1
ad_connect ila_dac_fifo/probe6 dac_fifo/din_enable_2
ad_connect ila_dac_fifo/probe7 dac_fifo/din_enable_3
ad_connect ila_dac_fifo/probe8  dac_fifo/dout_valid_0
ad_connect ila_dac_fifo/probe9  dac_fifo/dout_valid_1
ad_connect ila_dac_fifo/probe10 dac_fifo/dout_valid_2
ad_connect ila_dac_fifo/probe11 dac_fifo/dout_valid_3
ad_connect ila_dac_fifo/probe12 dac_fifo/dout_enable_0
ad_connect ila_dac_fifo/probe13 dac_fifo/dout_enable_1
ad_connect ila_dac_fifo/probe14 dac_fifo/dout_enable_2
ad_connect ila_dac_fifo/probe15 dac_fifo/dout_enable_3


ad_ip_instance ila ila_FIR_dec
ad_ip_parameter ila_FIR_dec CONFIG.C_MONITOR_TYPE Native
ad_ip_parameter ila_FIR_dec CONFIG.C_NUM_OF_PROBES 10
ad_ip_parameter ila_FIR_dec CONFIG.C_TRIGIN_EN false
ad_ip_parameter ila_FIR_dec CONFIG.C_PROBE0_WIDTH 16
ad_ip_parameter ila_FIR_dec CONFIG.C_PROBE1_WIDTH 16
ad_ip_parameter ila_FIR_dec CONFIG.C_PROBE2_WIDTH 32
ad_ip_parameter ila_FIR_dec CONFIG.C_PROBE3_WIDTH 1
ad_ip_parameter ila_FIR_dec CONFIG.C_PROBE4_WIDTH 1
ad_ip_parameter ila_FIR_dec CONFIG.C_PROBE5_WIDTH 16
ad_ip_parameter ila_FIR_dec CONFIG.C_PROBE6_WIDTH 16
ad_ip_parameter ila_FIR_dec CONFIG.C_PROBE7_WIDTH 32
ad_ip_parameter ila_FIR_dec CONFIG.C_PROBE8_WIDTH 1
ad_ip_parameter ila_FIR_dec CONFIG.C_PROBE9_WIDTH 1

ad_connect ila_FIR_dec/clk clkdiv/clk_out
# decimator 0
ad_connect ila_FIR_dec/probe0 fir_decimator_0/channel_0
ad_connect ila_FIR_dec/probe1 fir_decimator_0/channel_1
ad_connect ila_FIR_dec/probe2 fir_decimator_0/m_axis_data_tdata
ad_connect ila_FIR_dec/probe3 fir_decimator_0/s_axis_data_tready
ad_connect ila_FIR_dec/probe4 fir_decimator_0/m_axis_data_tvalid
# decimator 1
ad_connect ila_FIR_dec/probe5 fir_decimator_1/channel_0
ad_connect ila_FIR_dec/probe6 fir_decimator_1/channel_1
ad_connect ila_FIR_dec/probe7 fir_decimator_1/m_axis_data_tdata
ad_connect ila_FIR_dec/probe8 fir_decimator_1/s_axis_data_tready
ad_connect ila_FIR_dec/probe9 fir_decimator_1/m_axis_data_tvalid

regenerate_bd_layout
save_bd_design
validate_bd_design