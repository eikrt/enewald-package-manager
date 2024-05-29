#!/usr/bin/lua

function Test_fetch()
	TEST_NAME = "Fetch"
	local sh_script = [[
#!/bin/sh
./enewald fetch hello
]]

	local sh_script_file = "/tmp/temp_sh_script.sh"
	local file = io.open(sh_script_file, "w")
	if file then
		file:write(sh_script)
		file:close()
	else
		print("Could not open file '" .. sh_script_file .. "'")
		os.exit(1)
	end

	os.execute("chmod 0755 " .. sh_script_file)

	local handle = io.popen(sh_script_file)
	local output = handle:read("*a")
	handle:close()
	print("Sh script output:\n" .. output)

	local f = "/etc/enewald/sources.local/hello/hello-2.12/"
	local file = io.popen("[ -d " .. f .. ' ] && echo "exists" || echo "not exists"')
	local result = file:read("*a")
	file:close()

	if string.match(result, "exists") then
		print('\27[32m Test "' .. TEST_NAME .. '" passed')
	else
		print("\27[31m Test" .. TEST_NAME .. "failed")
	end

	os.remove(sh_script_file)
end

function Test_preinstall()
	TEST_NAME = "Preinstall"
	local sh_script = [[
#!/bin/sh
./enewald preinstall hello
]]

	local sh_script_file = "/tmp/temp_sh_script.sh"
	local file = io.open(sh_script_file, "w")
	if file then
		file:write(sh_script)
		file:close()
	else
		print("Could not open file '" .. sh_script_file .. "'")
		os.exit(1)
	end

	os.execute("chmod 0755 " .. sh_script_file)

	local handle = io.popen(sh_script_file)
	local output = handle:read("*a")
	handle:close()
	print("Sh script output:\n" .. output)

	local f = "/etc/enewald/sources.local/hello/hello-2.12/Makefile"
	local file = io.popen("[ -d " .. f .. ' ] && echo "exists" || echo "not exists"')
	local result = file:read("*a")
	file:close()

	if string.match(result, "exists") then
		print('\27[32m Test "' .. TEST_NAME .. '" passed')
	else
		print("\27[31m Test" .. TEST_NAME .. "failed")
	end

	os.remove(sh_script_file)
end

function Test_install()
	TEST_NAME = "Install"
	local sh_script = [[
#!/bin/sh
./enewald install hello
]]

	local sh_script_file = "/tmp/temp_sh_script.sh"
	local file = io.open(sh_script_file, "w")
	if file then
		file:write(sh_script)
		file:close()
	else
		print("Could not open file '" .. sh_script_file .. "'")
		os.exit(1)
	end

	os.execute("chmod 0755 " .. sh_script_file)

	local handle = io.popen(sh_script_file)
	local output = handle:read("*a")
	handle:close()
	print("Sh script output:\n" .. output)

	local f = "/etc/enewald/sources.local/hello/hello-2.12/hello"
	local file = io.popen("[ -d " .. f .. ' ] && echo "exists" || echo "not exists"')
	local result = file:read("*a")
	file:close()

	if string.match(result, "exists") then
		print('\27[32m Test "' .. TEST_NAME .. '" passed')
	else
		print("\27[31m Test" .. TEST_NAME .. "failed")
	end

	-- Cleanup: remove the temporary bash script
	os.remove(sh_script_file)
end

function Test_uninstall()
	TEST_NAME = "Uninstall"
	local sh_script = [[
#!/bin/sh
./enewald remove hello
]]

	-- Write the bash script to a temporary file
	local sh_script_file = "/tmp/temp_sh_script.sh"
	local file = io.open(sh_script_file, "w")
	if file then
		file:write(sh_script)
		file:close()
	else
		print("Could not open file '" .. sh_script_file .. "'")
		os.exit(1)
	end

	os.execute("chmod 0755 " .. sh_script_file)

	-- Execute the bash script
	local handle = io.popen(sh_script_file)
	local output = handle:read("*a")
	handle:close()
	print("Sh script output:\n" .. output)

	local dir = "/etc/enewald/sources.local/hello"
	local file = io.popen("[ -d " .. dir .. ' ] && echo "exists" || echo "not exists"')
	local result = file:read("*a")
	file:close()

	if string.match(result, "exists") then
		print('\27[32m Test "' .. TEST_NAME .. '" passed')
	else
		print("\27[31m Test " .. TEST_NAME .. " failed")
	end
	os.remove(sh_script_file)
end
Test_fetch()
Test_preinstall()
Test_install()
Test_uninstall()
