local M = {}
M.smt = getmetatable("")
M.og = {}
M.og = {
	__add = M.smt.__add,
	__mul = M.smt.__mul,
}

M.enable_concat_plus = function()
	M.smt.__add = function(a, b)
		return tostring(a) .. tostring(b)
	end
end

M.disable_concat_plus = function()
	M.smt.__add = M.og.__add
end

M.enable_mult_repeat = function()
	M.smt.__mul = function(a, b)
		return (type(a) == "string" and type(b) == "number") and a:rep(b)
			or (type(a) == "number" and type(b) == "string") and b:rep(a)
			or error("Attempt to multipy string with invalid type")
	end
end

M.disable_mult_repeat = function()
	M.smt.__mul = M.og.__mul
end

return M
