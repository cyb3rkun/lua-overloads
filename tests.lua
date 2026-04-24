---@class Test
---@field func function
---@field cleanup function

local M = {}

---@type table<string, Test>
M.tests = {}

M.tests.string_mult_repeat = {
	func = function()
		local s = require("strings")
		s.enable_mult_repeat()

		assert("Hello" * 3 == "HelloHelloHello")
		assert(2 * "hi" == "hihi")
		s.disable_mult_repeat()
		local success, err = pcall(function()
			return 2 * "hi" == "hihi"
		end)
		assert(not success, "Expected failure but got: " .. tostring(err))
	end,
	cleanup = function()
		local s = require("strings")
		s.disable_mult_repeat()
	end,
}

M.tests.string_plus_concat = {
	func = function()
		local s = require("strings")
		s.enable_concat_plus()
		assert("hello" + "tata" == "hellotata")
		assert("hello" + 3 == "hello3")
		assert(3 + "hello" == "3hello")
		s.disable_concat_plus()
		local success, err = pcall(function()
			return 2 + "hi" == "2hihi"
		end)
		assert(not success, "Expected failure but got: " .. tostring(err))
	end,
	cleanup = function()
		local s = require("strings")
		s.disable_concat_plus()
	end,
}

M.assert_eq = function(actual, expected, msg)
	if actual ~= expected then
		error(
			string.format(
				"%s\n expected %s\n got:\t%s",
				msg or "assertion failed",
				tostring(expected),
				tostring(actual)
			)
		)
	end
end
M.assert_neq = function(actual, expected, msg)
	if actual == expected then
		error(
			string.format(
				"%s\nexpected: not: %s\ngot:\t%s",
				msg or "assertion failed",
				tostring(expected),
				tostring(actual)
			)
		)
	end
end

M.assert_false = function(val, msg)
	M.assert_eq(val, false, msg)
end

M.assert_true = function(val, msg)
	M.assert_eq(val, true, msg)
end

---@param name string # The name of the test as a string
---@param test Test
M.register = function(name, test)
	assert(type(test.func) == "function", string.format('test "%s" missing func', name))
	M.tests[name] = test
end
M.add_test = M.register

M.test_all = function()
	local passed = 0
	local total = 0

	for t_name, test in pairs(M.tests) do
		total = total + 1
		local success, err = pcall(test.func)
		pcall(test.cleanup)
		if success then
			passed = passed + 1
			print(string.format("[PASS] %s", t_name))
		else
			print(string.format("[FAIL] %s: %s", t_name, err))
		end
	end
	print(string.format("\nResults: %d/%d passed", passed, total))
end

---@param name string string name of the test to run
M.run_test = function(name)
	if not M.tests[name] then
		error('there is no test named "' .. name .. '"')
		return
	end
	local test = M.tests[name]
	local success, err = pcall(test.func)
	pcall(test.cleanup)
	if success then
		print(string.format("[PASS] %s", name))
	else
		print(string.format("[FAIL] %s: %s", name, err))
	end
end

if arg and arg[1] == "--all" then
	M.test_all()
end
return M
