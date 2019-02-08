local chLirmen = {

    abl = {
    },
    
    
    TutTeach = function(self,abl) return "Find the appropriate scroll" end,
    
    Teach = function(self,abl)
        if self.abl[abl].start then return false end
    end
}

return chLirmen