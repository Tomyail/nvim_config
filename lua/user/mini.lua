local status_ok, bufremove = pcall(require, "mini.bufremove")
if status_ok then
	bufremove.setup()
end

--[[ local status_ok, animate = pcall(require, "mini.animate") ]]
--[[ if status_ok then ]]
--[[ 	animate.setup() ]]
--[[ end ]]
local status_ok, indentscope = pcall(require, "mini.indentscope")
if status_ok then
	indentscope.setup()
end

local status_ok, bracketed = pcall(require, "mini.bracketed")
if status_ok then
	bracketed.setup()
end
