#!/usr/bin/luajit
-- luajit or anything you want

local clock = os.clock
local http = require("socket.http")
local ltn12 = require("ltn12")

local timeout = 3
local url_str = "http://btwosoft.ru/adwlan/check.php"

function sleep(n)
	local t0 = clock()
	while clock() - t0 <= n do end
end 

function do_access(ip)
	command = string.format("echo %s", ip)
	os.execute(command)
end

while true do

	p = {}

	f, s, t = http.request{
		url = url_str,
		sink = ltn12.sink.table(p)
	}

	result = table.concat(p, "")
	print("new request:")
	print(result)

	if result ~= "" then
		for token in string.gmatch(result, '([^,]+)') do
			do_access(token)
		end
	end
	
	sleep(timeout)
	print("new iteration")
end
