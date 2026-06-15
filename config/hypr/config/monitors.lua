-- Laptop monitor
hl.monitor({
	output = "desc:LG Display 0x06AA",
	mode = "3840x2400@60.0",
	-- mode = "highres",
	position = "5120x1899",
	scale = "2",
	bitdepth = 10,
})

-- Work monitors
hl.monitor({
	output = "desc:Dell Inc. DELL U3421WE GLVW653",
	mode = "3440x1440@59.97",
	-- mode = "preferred",
	position = "4587x459",
	scale = "1",
})

hl.monitor({
	output = "desc:Dell Inc. DELL U2722DE 6TGK6P3",
	mode = "2560x1440@59.95",
	-- mode = "highres",
	position = "3147x0",
	scale = "1",
	transform = 3,
})

-- Home monitors (@120 Hz)
hl.monitor({
	output = "desc:Ancor Communications Inc ASUS MG279 0x0000FCE6",
	mode = "2560x1440@119.88",
	position = "0x1659",
	scale = "1",
})

hl.monitor({
	output = "desc:Ancor Communications Inc ASUS MG279 0x00023E15",
	mode = "2560x1440@119.88",
	position = "2560x1659",
	scale = "1",
})

-- Every other monitor (fallback)
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "1",
})

-- on the portrait monitor split top layot on master
hl.workspace_rule({
	workspace = "m[desc:Dell Inc. DELL U2722DE 6TGK6P3]",
	layout_opts = { orientation = "top" },
})
