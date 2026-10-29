hl.monitor({
	mode = "2160x1440@59.95HZ",
	output = "eDP-1",
	scale = 1.5,
})

-- Hyprland 0.57 defaults this to true, which on Haswell/crocus only advertises
-- opaque KMS formats (XR24/etc). Mesa then exposes no Wayland EGL configs with
-- alpha, and clients like Alacritty fail with "failed to find suitable GL configuration."
hl.config({
	quirks = {
		skip_non_kms_dmabuf_formats = false,
	},
})
