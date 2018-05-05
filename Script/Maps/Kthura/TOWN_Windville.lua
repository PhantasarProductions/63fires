--[[ Generated by the Kthura Map Editor
     Generated: 05 May 2018; 16:43:31


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
	KNO={}
	MapObjects["Outside"][#MapObjects["Outside"]+1] = KNO
		KNO["KIND"] = "TiledArea"
		KNO["COORD"] = { x = 448, y = 1056 } 
		KNO["INSERT"] = { x = -448, y = -1056 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 224, height = 64 } 
		KNO["TAG"] = ""
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 2
		KNO["TEXTURE"] = "GFX/TEXTURES/WINDVILLE/STRAAT.PNG"
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
		KNO["KIND"] = "TiledArea"
		KNO["COORD"] = { x = 64, y = 992 } 
		KNO["INSERT"] = { x = -64, y = -992 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 1088, height = 64 } 
		KNO["TAG"] = ""
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 2
		KNO["TEXTURE"] = "GFX/TEXTURES/WINDVILLE/STRAAT.PNG"
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
		KNO["COORD"] = { x = 512, y = 864 } 
		KNO["INSERT"] = { x = 0, y = 0 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 96, height = 192 } 
		KNO["TAG"] = "IntroNino"
			TagMap["Outside"]["IntroNino"] = KNO
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 16777215
		KNO["TEXTURE"] = ""
		KNO["CURRENTFRAME"] = 0
		KNO["FRAMESPEED"] = -1
		KNO["ALPHA"] = 1.0000000000000000
		KNO["VISIBLE"] = true
		KNO["COLOR"] = { r = 153, g = 0, b = 199 } 
		KNO["IMPASSIBLE"] = false
		KNO["FORCEPASSIBLE"] = false
		KNO["SCALE"] = { x = 1000, y = 1000 } 
		KNO["BLEND"] = 0
	KNO={}
	MapObjects["Outside"][#MapObjects["Outside"]+1] = KNO
		KNO["KIND"] = "Obstacle"
		KNO["COORD"] = { x = 880, y = 864 } 
		KNO["INSERT"] = { x = 0, y = 0 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 0, height = 0 } 
		KNO["TAG"] = ""
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 20
		KNO["TEXTURE"] = "GFX/TEXTURES/WINDVILLE/HOUSE.PNG"
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
		KNO["COORD"] = { x = 240, y = 896 } 
		KNO["INSERT"] = { x = 0, y = 0 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 0, height = 0 } 
		KNO["TAG"] = ""
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 20
		KNO["TEXTURE"] = "GFX/TEXTURES/WINDVILLE/HOUSE.PNG"
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
		KNO["COORD"] = { x = 784, y = 864 } 
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
		KNO["COLOR"] = { r = 255, g = 255, b = 255 } 
		KNO["IMPASSIBLE"] = true
		KNO["FORCEPASSIBLE"] = false
		KNO["SCALE"] = { x = 1000, y = 1000 } 
		KNO["BLEND"] = 0
	KNO={}
	MapObjects["Outside"][#MapObjects["Outside"]+1] = KNO
		KNO["KIND"] = "Obstacle"
		KNO["COORD"] = { x = 336, y = 896 } 
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
		KNO["COLOR"] = { r = 255, g = 255, b = 255 } 
		KNO["IMPASSIBLE"] = true
		KNO["FORCEPASSIBLE"] = false
		KNO["SCALE"] = { x = 1000, y = 1000 } 
		KNO["BLEND"] = 0
	KNO={}
	MapObjects["Outside"][#MapObjects["Outside"]+1] = KNO
		KNO["KIND"] = "Obstacle"
		KNO["COORD"] = { x = 336, y = 749 } 
		KNO["INSERT"] = { x = 0, y = 0 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 0, height = 0 } 
		KNO["TAG"] = ""
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 25
		KNO["TEXTURE"] = "GFX/TEXTURES/WINDVILLE/MOLEN/WIEKEN.JPBF"
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
		KNO["COORD"] = { x = 785, y = 722 } 
		KNO["INSERT"] = { x = 0, y = 0 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 0, height = 0 } 
		KNO["TAG"] = ""
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 25
		KNO["TEXTURE"] = "GFX/TEXTURES/WINDVILLE/MOLEN/WIEKEN.JPBF"
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
		KNO["KIND"] = "Zone"
		KNO["COORD"] = { x = 736, y = 800 } 
		KNO["INSERT"] = { x = 0, y = 0 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 288, height = 64 } 
		KNO["TAG"] = "Zone 02DF1B1A"
			TagMap["Outside"]["Zone 02DF1B1A"] = KNO
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
		KNO["COORD"] = { x = 96, y = 832 } 
		KNO["INSERT"] = { x = 0, y = 0 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 288, height = 64 } 
		KNO["TAG"] = "Zone 35EA3A0D"
			TagMap["Outside"]["Zone 35EA3A0D"] = KNO
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
		KNO["KIND"] = "TiledArea"
		KNO["COORD"] = { x = 104, y = 880 } 
		KNO["INSERT"] = { x = -104, y = -880 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 143, height = 89 } 
		KNO["TAG"] = ""
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 2
		KNO["TEXTURE"] = "GFX/TEXTURES/ROAD/GRASS2.PNG"
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
		KNO["KIND"] = "TiledArea"
		KNO["COORD"] = { x = 300, y = 872 } 
		KNO["INSERT"] = { x = -300, y = -872 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 75, height = 89 } 
		KNO["TAG"] = ""
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 2
		KNO["TEXTURE"] = "GFX/TEXTURES/ROAD/GRASS2.PNG"
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
		KNO["KIND"] = "TiledArea"
		KNO["COORD"] = { x = 94, y = 764 } 
		KNO["INSERT"] = { x = -94, y = -764 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 291, height = 120 } 
		KNO["TAG"] = ""
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 2
		KNO["TEXTURE"] = "GFX/TEXTURES/ROAD/GRASS2.PNG"
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
		KNO["KIND"] = "TiledArea"
		KNO["COORD"] = { x = 676, y = 712 } 
		KNO["INSERT"] = { x = -676, y = -712 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 197, height = 206 } 
		KNO["TAG"] = ""
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 2
		KNO["TEXTURE"] = "GFX/TEXTURES/ROAD/GRASS2.PNG"
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
		KNO["KIND"] = "TiledArea"
		KNO["COORD"] = { x = 937, y = 714 } 
		KNO["INSERT"] = { x = -937, y = -714 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 102, height = 216 } 
		KNO["TAG"] = ""
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 2
		KNO["TEXTURE"] = "GFX/TEXTURES/ROAD/GRASS2.PNG"
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
		KNO["KIND"] = "TiledArea"
		KNO["COORD"] = { x = 869, y = 855 } 
		KNO["INSERT"] = { x = -869, y = -855 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 89, height = 104 } 
		KNO["TAG"] = ""
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 2
		KNO["TEXTURE"] = "GFX/TEXTURES/WINDVILLE/STRAAT.PNG"
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
		KNO["KIND"] = "TiledArea"
		KNO["COORD"] = { x = 241, y = 882 } 
		KNO["INSERT"] = { x = -241, y = -882 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 68, height = 103 } 
		KNO["TAG"] = ""
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 2
		KNO["TEXTURE"] = "GFX/TEXTURES/WINDVILLE/STRAAT.PNG"
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
		KNO["KIND"] = "TiledArea"
		KNO["COORD"] = { x = 68, y = 953 } 
		KNO["INSERT"] = { x = -68, y = -953 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 1085, height = 50 } 
		KNO["TAG"] = ""
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 2
		KNO["TEXTURE"] = "GFX/TEXTURES/WINDVILLE/STRAAT.PNG"
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
		KNO["KIND"] = "TiledArea"
		KNO["COORD"] = { x = 676, y = 913 } 
		KNO["INSERT"] = { x = -676, y = -913 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 393, height = 46 } 
		KNO["TAG"] = ""
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 2
		KNO["TEXTURE"] = "GFX/TEXTURES/WINDVILLE/STRAAT.PNG"
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
		KNO["KIND"] = "TiledArea"
		KNO["COORD"] = { x = 36, y = 740 } 
		KNO["INSERT"] = { x = -36, y = -740 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 70, height = 317 } 
		KNO["TAG"] = ""
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 3
		KNO["TEXTURE"] = "GFX/TEXTURES/WINDVILLE/STRAAT.PNG"
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
		KNO["KIND"] = "TiledArea"
		KNO["COORD"] = { x = 39, y = 677 } 
		KNO["INSERT"] = { x = -39, y = -677 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 675, height = 97 } 
		KNO["TAG"] = ""
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 3
		KNO["TEXTURE"] = "GFX/TEXTURES/WINDVILLE/STRAAT.PNG"
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
		KNO["KIND"] = "TiledArea"
		KNO["COORD"] = { x = 372, y = 758 } 
		KNO["INSERT"] = { x = -372, y = -758 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 341, height = 209 } 
		KNO["TAG"] = ""
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 3
		KNO["TEXTURE"] = "GFX/TEXTURES/WINDVILLE/STRAAT.PNG"
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
		KNO["KIND"] = "TiledArea"
		KNO["COORD"] = { x = 1028, y = 676 } 
		KNO["INSERT"] = { x = -1028, y = -676 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 124, height = 295 } 
		KNO["TAG"] = ""
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 2
		KNO["TEXTURE"] = "GFX/TEXTURES/WINDVILLE/STRAAT.PNG"
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
		KNO["KIND"] = "TiledArea"
		KNO["COORD"] = { x = 712, y = 685 } 
		KNO["INSERT"] = { x = -712, y = -685 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 365, height = 57 } 
		KNO["TAG"] = ""
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 2
		KNO["TEXTURE"] = "GFX/TEXTURES/WINDVILLE/STRAAT.PNG"
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
		KNO["KIND"] = "TiledArea"
		KNO["COORD"] = { x = 709, y = 676 } 
		KNO["INSERT"] = { x = -709, y = -676 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 348, height = 36 } 
		KNO["TAG"] = ""
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 2
		KNO["TEXTURE"] = "GFX/TEXTURES/WINDVILLE/STRAAT.PNG"
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
		KNO["KIND"] = "TiledArea"
		KNO["COORD"] = { x = 704, y = 1040 } 
		KNO["INSERT"] = { x = 0, y = 0 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 448, height = 32 } 
		KNO["TAG"] = ""
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 20
		KNO["TEXTURE"] = "GFX/TEXTURES/WINDVILLE/MUURTJE_STEEN.PNG"
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
		KNO["KIND"] = "TiledArea"
		KNO["COORD"] = { x = 32, y = 1040 } 
		KNO["INSERT"] = { x = 0, y = 0 } 
		KNO["ROTATION"] = 0
		KNO["SIZE"] = { width = 384, height = 32 } 
		KNO["TAG"] = ""
		KNO["LABELS"] = ""
		KNO["DOMINANCE"] = 20
		KNO["TEXTURE"] = "GFX/TEXTURES/WINDVILLE/MUURTJE_STEEN.PNG"
		KNO["CURRENTFRAME"] = 0
		KNO["FRAMESPEED"] = -1
		KNO["ALPHA"] = 1.0000000000000000
		KNO["VISIBLE"] = true
		KNO["COLOR"] = { r = 255, g = 255, b = 255 } 
		KNO["IMPASSIBLE"] = true
		KNO["FORCEPASSIBLE"] = false
		KNO["SCALE"] = { x = 1000, y = 1000 } 
		KNO["BLEND"] = 0

-- Outside



return Kthura
