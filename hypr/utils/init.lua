function hostname()
	local p = assert(io.popen("hostname", 'r'))
	local s = assert(p:read("a"))
	p:close()
	return (s:gsub("%s+$", ""))
end

function notify(message)
	local p = assert(io.popen("notify-send " .. message))
	p:close()
end
