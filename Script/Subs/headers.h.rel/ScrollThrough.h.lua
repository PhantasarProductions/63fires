local tst

local function ust()
  -- $USE script/subs/ScrollThrough AS tst
end



function st_Show()
    if not tst then return end
    tst:Show()
end    


function st_Txt(text,R,G,B)
    ust()
    tst:Txt(text,R or 255,G or 255,B or 255)
    kcbdraw('after',st_Show)
end
