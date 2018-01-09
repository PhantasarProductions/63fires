local fld = { nomerge=true }

fld.mode = 'status'

local function go_status() fld.mode='status' end
local function go_inventaris() fld.mode='inventaris' end
local function go_ability() fld.mode='ability' end

fld.iconstrip = {
     {icon="status",tut="Statistics, data\nJust the general data about your character can be found here",cb=go_status},
     {icon="inventaris", tut="What items are you carrying with you?", cb=go_inventaris},
     {icon='vaardigheden', tut='Skills, special moves, spells?\nWhatever a character can do is listed here!',cb=go_ability},
     {icon='help',tut="Help me, Ryanna! You're my only hope!",iconstriphelp}
}


fld.modes = {

    status = function (  ) 
    end,
    
    inventaris = function ()
    end,
    
    ability = function()
    end

}


return fld