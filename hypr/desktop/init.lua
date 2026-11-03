-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
	output = "DP-4",
	mode = "3840x2160@240HZ",
	position = "0x0",
	scale = 1,
	bitdepth = 10,
	supports_wide_color = true,
	supports_hdr = true,
	cm = "hdr",
	sdr_min_luminance = 0.05,
	sdr_max_luminance = 200,
})
