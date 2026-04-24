---@type LuxManifest
return {

	name = "overloads",
	namespace = "luxa.overloads",
	license = {
		spdx = "MIT",
		files = { "LICENSE" },
	},
	lua_modules = {
		{
			name = "strings",
			sources = { "strings.lua" },
		},
	},
}
-- NOTE:
-- still many things to work out and refine regarding the package
-- manifest standard, this is only a prototype and there will
-- be breaking changes!
--
--@class LuaModule
--@field name string
--@field sources string[]?
--@field source_dir string?
