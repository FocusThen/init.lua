require("focusthen.set")
require("focusthen.remap")
require("focusthen.lazy_init")

function R(name)
	require("plenary.reload").reload_module(name)
end

function P(v)
	print(vim.inspect(v))
	return v
end
