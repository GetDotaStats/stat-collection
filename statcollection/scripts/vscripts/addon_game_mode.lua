-- Ensure lod exists
if _G.lod == nil then
    _G.lod = class({})
end

-- Load modules
require('lod')

-- Stat collection
require('lib.statcollection')
statcollection.addStats{{
	modID = 'XXXXXXXXXXXXXXXXXXX' --GET THIS FROM http://getdotastats.com/#d2mods__my_mods
}}

if lod == nil then
	print('LOD FAILED TO INIT!')
	return
end