--[[ Generated by the Kthura Map Editor
     Generated: 04 May 2018; 19:42:05


     This file has been set up as an import



]]



local Kthura = {}
local Meta = {}
Meta["AltEncounterTune"] = ""
Meta["Arena"] = ""
Meta["Foes1"] = ""
Meta["Foes2"] = ""
Meta["Foes3"] = ""
Meta["Foes_NG+"] = ""
Meta["MaxEnc"] = ""
Meta["Music"] = "Music/Town/Vivacity.mp3"
Meta["NamedZones"] = ""
Meta["NoEncZones"] = ""
Meta["NoSaveZones"] = ""
Meta["RandomItems"] = ""
Meta["RandomItems_NG+"] = ""
Meta["Title"] = "The city of Windville"



local MapObjects = {}
local BM_Grid = {}
local TagMap = {}
local LabelMap = {}
local KNO
Kthura = { MapObjects=MapObjects, Grid=BM_Grid, TagMap = TagMap, LabelMap=LabelMap, Meta=Meta }
MapObjects["Outside"] = {}
LabelMap["Outside"] = {}
TagMap["Outside"] = {}

-- Outside
	BM_Grid["Outside"] = "32x32"
	KNO={}
	MapObjects["Outside"][#MapObjects["Outside"]+1] = KNO
		KNO["KIND"] = "Exit"
		KNO["COORD"] = { x = 560, y = 1030 } 
		KNO["INSERT"] = { x = 0, y = 0 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 0, height = 0 } 
		KNO["TAG"] = "Start"
			TagMap["Outside"]["Start"] = KNO
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 20
		KNO["TEXTURE"] = ""
		KNO["CURRENTFRAME"] = 0
		KNO["FRAMESPEED"] = -1
		KNO["ALPHA"] = 1.0000000000000000
		KNO["VISIBLE"] = true
		KNO["COLOR"] = { r = 255, g = 255, b = 255 } 
		KNO["IMPASSIBLE"] = false
		KNO["FORCEPASSIBLE"] = false
		KNO["SCALE"] = { x = 1000, y = 1000 } 
		KNO["BLEND"] = 0
	KNO={}
	MapObjects["Outside"][#MapObjects["Outside"]+1] = KNO
		KNO["KIND"] = "Obstacle"
		KNO["COORD"] = { x = 688, y = 958 } 
		KNO["INSERT"] = { x = 0, y = 0 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 0, height = 0 } 
		KNO["TAG"] = ""
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 21
		KNO["TEXTURE"] = "GFX/TEXTURES/WINDVILLE/MOLEN/WIEKEN.JPBF"
		KNO["CURRENTFRAME"] = 0
		KNO["FRAMESPEED"] = -1
		KNO["ALPHA"] = 1.0000000000000000
		KNO["VISIBLE"] = true
		KNO["COLOR"] = { r = 255, g = 255, b = 255 } 
		KNO["IMPASSIBLE"] = false
		KNO["FORCEPASSIBLE"] = false
		KNO["SCALE"] = { x = 1000, y = 1000 } 
		KNO["BLEND"] = 0
	KNO={}
	MapObjects["Outside"][#MapObjects["Outside"]+1] = KNO
		KNO["KIND"] = "Obstacle"
		KNO["COORD"] = { x = 432, y = 960 } 
		KNO["INSERT"] = { x = 0, y = 0 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 0, height = 0 } 
		KNO["TAG"] = ""
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 21
		KNO["TEXTURE"] = "GFX/TEXTURES/WINDVILLE/MOLEN/WIEKEN.JPBF"
		KNO["CURRENTFRAME"] = 0
		KNO["FRAMESPEED"] = -1
		KNO["ALPHA"] = 1.0000000000000000
		KNO["VISIBLE"] = true
		KNO["COLOR"] = { r = 255, g = 255, b = 255 } 
		KNO["IMPASSIBLE"] = false
		KNO["FORCEPASSIBLE"] = false
		KNO["SCALE"] = { x = 1000, y = 1000 } 
		KNO["BLEND"] = 0
	KNO={}
	MapObjects["Outside"][#MapObjects["Outside"]+1] = KNO
		KNO["KIND"] = "Zone"
		KNO["COORD"] = { x = 416, y = 1072 } 
		KNO["INSERT"] = { x = 0, y = 0 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 32, height = 96 } 
		KNO["TAG"] = "Zone 02821D96"
			TagMap["Outside"]["Zone 02821D96"] = KNO
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 16777215
		KNO["TEXTURE"] = ""
		KNO["CURRENTFRAME"] = 0
		KNO["FRAMESPEED"] = -1
		KNO["ALPHA"] = 1.0000000000000000
		KNO["VISIBLE"] = true
		KNO["COLOR"] = { r = 153, g = 0, b = 199 } 
		KNO["IMPASSIBLE"] = true
		KNO["FORCEPASSIBLE"] = false
		KNO["SCALE"] = { x = 1000, y = 1000 } 
		KNO["BLEND"] = 0
	KNO={}
	MapObjects["Outside"][#MapObjects["Outside"]+1] = KNO
		KNO["KIND"] = "Zone"
		KNO["COORD"] = { x = 416, y = 1168 } 
		KNO["INSERT"] = { x = 0, y = 0 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 288, height = 32 } 
		KNO["TAG"] = "Zone 01FEE722"
			TagMap["Outside"]["Zone 01FEE722"] = KNO
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 16777215
		KNO["TEXTURE"] = ""
		KNO["CURRENTFRAME"] = 0
		KNO["FRAMESPEED"] = -1
		KNO["ALPHA"] = 1.0000000000000000
		KNO["VISIBLE"] = true
		KNO["COLOR"] = { r = 38, g = 59, b = 197 } 
		KNO["IMPASSIBLE"] = true
		KNO["FORCEPASSIBLE"] = false
		KNO["SCALE"] = { x = 1000, y = 1000 } 
		KNO["BLEND"] = 0
	KNO={}
	MapObjects["Outside"][#MapObjects["Outside"]+1] = KNO
		KNO["KIND"] = "Zone"
		KNO["COORD"] = { x = 672, y = 1072 } 
		KNO["INSERT"] = { x = 0, y = 0 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 32, height = 96 } 
		KNO["TAG"] = "Zone 2578A2AF"
			TagMap["Outside"]["Zone 2578A2AF"] = KNO
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 16777215
		KNO["TEXTURE"] = ""
		KNO["CURRENTFRAME"] = 0
		KNO["FRAMESPEED"] = -1
		KNO["ALPHA"] = 1.0000000000000000
		KNO["VISIBLE"] = true
		KNO["COLOR"] = { r = 178, g = 92, b = 113 } 
		KNO["IMPASSIBLE"] = true
		KNO["FORCEPASSIBLE"] = false
		KNO["SCALE"] = { x = 1000, y = 1000 } 
		KNO["BLEND"] = 0
	KNO={}
	MapObjects["Outside"][#MapObjects["Outside"]+1] = KNO
		KNO["KIND"] = "Zone"
		KNO["COORD"] = { x = 448, y = 1072 } 
		KNO["INSERT"] = { x = 0, y = 0 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 224, height = 96 } 
		KNO["TAG"] = "Beaufort"
			TagMap["Outside"]["Beaufort"] = KNO
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 16777215
		KNO["TEXTURE"] = ""
		KNO["CURRENTFRAME"] = 0
		KNO["FRAMESPEED"] = -1
		KNO["ALPHA"] = 1.0000000000000000
		KNO["VISIBLE"] = true
		KNO["COLOR"] = { r = 200, g = 187, b = 154 } 
		KNO["IMPASSIBLE"] = false
		KNO["FORCEPASSIBLE"] = false
		KNO["SCALE"] = { x = 1000, y = 1000 } 
		KNO["BLEND"] = 0
	KNO={}
	MapObjects["Outside"][#MapObjects["Outside"]+1] = KNO
		KNO["KIND"] = "Obstacle"
		KNO["COORD"] = { x = 720, y = 1216 } 
		KNO["INSERT"] = { x = 0, y = 0 } 
		KNO["ROTATION"] = 45
		KNO["SIZE"] = { width = 0, height = 0 } 
		KNO["TAG"] = ""
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 20
		KNO["TEXTURE"] = "GFX/TEXTURES/TREES/SPAR.PNG"
		KNO["CURRENTFRAME"] = 0
		KNO["FRAMESPEED"] = -1
		KNO["ALPHA"] = 1.0000000000000000
		KNO["VISIBLE"] = true
		KNO["COLOR"] = { r = 255, g = 255, b = 255 } 
		KNO["IMPASSIBLE"] = true
		KNO["FORCEPASSIBLE"] = false
		KNO["SCALE"] = { x = 1000, y = 1000 } 
		KNO["BLEND"] = 0
	KNO={}
	MapObjects["Outside"][#MapObjects["Outside"]+1] = KNO
		KNO["KIND"] = "Obstacle"
		KNO["COORD"] = { x = 688, y = 1103 } 
		KNO["INSERT"] = { x = 0, y = 0 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 0, height = 0 } 
		KNO["TAG"] = ""
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 20
		KNO["TEXTURE"] = "GFX/TEXTURES/WINDVILLE/MOLEN/MILLTOWER.PNG"
		KNO["CURRENTFRAME"] = 0
		KNO["FRAMESPEED"] = -1
		KNO["ALPHA"] = 1.0000000000000000
		KNO["VISIBLE"] = true
		KNO["COLOR"] = { r = 255, g = 255, b = 200 } 
		KNO["IMPASSIBLE"] = true
		KNO["FORCEPASSIBLE"] = false
		KNO["SCALE"] = { x = 1000, y = 1000 } 
		KNO["BLEND"] = 0
	KNO={}
	MapObjects["Outside"][#MapObjects["Outside"]+1] = KNO
		KNO["KIND"] = "Obstacle"
		KNO["COORD"] = { x = 432, y = 1100 } 
		KNO["INSERT"] = { x = 0, y = 0 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 0, height = 0 } 
		KNO["TAG"] = ""
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 20
		KNO["TEXTURE"] = "GFX/TEXTURES/WINDVILLE/MOLEN/MILLTOWER.PNG"
		KNO["CURRENTFRAME"] = 0
		KNO["FRAMESPEED"] = -1
		KNO["ALPHA"] = 1.0000000000000000
		KNO["VISIBLE"] = true
		KNO["COLOR"] = { r = 255, g = 200, b = 255 } 
		KNO["IMPASSIBLE"] = true
		KNO["FORCEPASSIBLE"] = false
		KNO["SCALE"] = { x = 1000, y = 1000 } 
		KNO["BLEND"] = 0

-- Outside



return Kthura
