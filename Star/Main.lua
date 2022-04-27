---@diagnostic disable: undefined-field
local MoniterX, MoniterY = term.getSize()

-- :)
-- smiles for anyone reading this code
-- it will be needed


local BigFont = require("libs.bigfont")





local Settings = {}
local function VerifySetting(setting,default)
    if Settings[setting] == nil then
        Settings[setting] = default
    end
end

local function LoadSettings()
    local SettingsFile = fs.open("Star/UserData/Settings.conf", "r")
    if SettingsFile then 
        Settings = SettingsFile.readAll()
        if Settings == nil then
            Settings = {}
        else
            textutils.unserialize(Settings)
        end

    end

    if type(Settings) ~= "table" then
        Settings = {}
    end
    
    

end
local function SaveSettings()
    local SettingsFile = fs.open("Star/UserData/Settings.conf", "w")
    SettingsFile.write(textutils.serialize(Settings))
    SettingsFile.close()
end


LoadSettings()
--defines it all frist to make sure that if its not loadded then it will auto create it
VerifySetting("MainColor",colors.green)
VerifySetting("SizeOfLibarySideTab",10)

SaveSettings()






local RootWindows = term.native()
local WindowObject = window.create(term.current(), 1, 1, MoniterX, MoniterY,false)
term.redirect(WindowObject)

local function UpdateDoubleBuffer()
    WindowObject.setVisible(true)
    WindowObject.redraw()
    WindowObject.setVisible(false)
end

local function LoadProgram(ProgramName)
    term.redirect(RootWindows)
    local yellowbox = require("libs.yellowbox")
    local file = fs.open("Star/libs/bios.lua", "rb")
    local vm = yellowbox:new(file.readAll())
    file.close()
    vm:loadVFS("Star/Apps/" .. ProgramName .. "/Data.vfs")
    local peripherals = peripheral.getNames()
    for i = 1, #peripherals do
        vm:exportPeripheral(peripherals[i], peripherals[i])
    end
    vm:resume()
    while vm.running do
        vm:queueEvent(os.pullEventRaw())
        vm:resume()
    end
end

local function DrawTextWithBoarder(TextString,PosX,PosY,OutLineColor,TextColor,TextBackgroundColor,NONTextColor,UseLargePadding)
    --draw butten
    term.setCursorPos(PosX,PosY)
    term.setBackgroundColor(TextBackgroundColor)
    term.setTextColor(TextColor)
    term.write(TextString)

    --draw outline
    
    if UseLargePadding then
        term.setBackgroundColor(OutLineColor)
        term.setCursorPos(PosX - 1,PosY - 1)
        
        for i =1, #TextString + 2 do
            term.write(" ")
        end

        term.setCursorPos(PosX - 1,PosY + 1)
        for i =1, #TextString + 2 do
            term.write(" ")
        end

        term.setCursorPos(PosX - 1,PosY - 0)
        term.write(" ")
        term.setCursorPos(PosX + #TextString,PosY - 0)
        term.write(" ")
    else
        --top left
        term.setBackgroundColor(OutLineColor)
        term.setTextColour(NONTextColor)
        term.setCursorPos(PosX - 1,PosY - 1)
        term.write("\159")

        --left
        term.setCursorPos(PosX - 1,PosY - 0)
        term.write("\149")

        --top
        term.setCursorPos(PosX,PosY - 1)
        for i=1, #TextString do
            term.write("\143")
        end

        --top right
        term.setBackgroundColor(NONTextColor)
        term.setTextColour(OutLineColor)
        term.setCursorPos(PosX + #TextString,PosY - 1)
        term.write("\144")

        --bottom left
        term.setCursorPos(PosX - 1,PosY + 1)
        term.write("\130")

        --bottom right
        term.setCursorPos(PosX + #TextString,PosY + 1)
        term.write("\129")

        

        --right
        term.setCursorPos(PosX + #TextString,PosY - 0)
        term.write("\149")

        --bottem
        term.setCursorPos(PosX,PosY + 1)
        for i=1, #TextString do
            term.write("\131")
        end
        


    end 
end



--https://pokechu22.github.io/Burger/1.16.5.html#sounds
local SoundEffects = {}
--SoundEffects.BootSound = "ambient/underwater/enter3"
SoundEffects.BootSound = "block.beacon.activate"
SoundEffects.BackgroundEffect = "ambient/underwater/underwater_ambience"
SoundEffects.ClickSound = "step/stone1"
SoundEffects.SettingsChangeSeccess = "random/anvil_use"
SoundEffects.SettingsChangeFail = "random/anvil_break"

--block.end_portal.spawn

local MenuSelectioned = "library"
local AppSlected = nil
local ProgramOpenedPath = nil




local function DrawTabMenu()
    term.setCursorPos(1,1)
    term.setBackgroundColor(colors.black)
    term.clearLine()
    term.setCursorPos(1,2)
    term.setBackgroundColor(colors.black)
    term.clearLine()


    if MenuSelectioned == "library" then
        DrawTextWithBoarder("Library",3,1,Settings.MainColor,colors.white,Settings.MainColor,colors.black,false)
    else
        DrawTextWithBoarder("Library",3,1,colors.gray,colors.white,colors.gray,colors.black,false)
    end

    if MenuSelectioned == "Profile" then
        DrawTextWithBoarder("Profile",12,1,Settings.MainColor,colors.white,Settings.MainColor,colors.black,false)
    else
        DrawTextWithBoarder("Profile",12,1,colors.gray,colors.white,colors.gray,colors.black,false)
    end

    if MenuSelectioned == "Store" then
        DrawTextWithBoarder("Store",21,1,Settings.MainColor,colors.white,Settings.MainColor,colors.black,false)
    else
        DrawTextWithBoarder("Store",21,1,colors.gray,colors.white,colors.gray,colors.black,false)
    end



    term.setBackgroundColor(colors.lightGray)
    term.setTextColor(colors.black)
     -- term.setCursorPos(9, 1)
     -- term.write("|")
     -- term.setCursorPos(17, 1)
     -- term.write("|")

    term.setBackgroundColor(colors.lightGray)
    term.setTextColor(colors.white)
end


local function TextCutOFF(Text, Length, AddExtra)
    for i = 1, Length do
       
        if AddExtra == true then
            local NewText = Text:sub(1, Length)
            for i=1, Length - #Text do
                NewText = NewText .. " "
            end
            return NewText
        else
            return Text:sub(1, Length)
        end
        
    end

end



----------------------------------
--- Code todo with libary page ---
----------------------------------

local function DrawLibaryInfoPage()
    paintutils.drawFilledBox(Settings.SizeOfLibarySideTab + 1, 2, MoniterX, MoniterY, colors.gray, colors.gray)
    

    if AppSlected then
        --draws background for title text
        paintutils.drawFilledBox(Settings.SizeOfLibarySideTab + 1, 2, MoniterX, 6, Settings.MainColor, colors.lightGray,"X")

        --draws big title text
        term.setCursorPos(Settings.SizeOfLibarySideTab + 3, 4)
        BigFont.bigPrint(tostring(AppSlected))
        --draws play butten
        DrawTextWithBoarder("Play",Settings.SizeOfLibarySideTab + 4, 9,Settings.MainColor,colors.white,Settings.MainColor ,colors.gray, false)
        DrawTextWithBoarder("Settings",Settings.SizeOfLibarySideTab + 4, 12,colors.lightGray,colors.white,colors.lightGray,colors.gray, false)

    end

    paintutils.drawBox(Settings.SizeOfLibarySideTab + 1, 2, MoniterX, MoniterY, colors.black, colors.black)
end

local function DrawlibraryMenu()
    local ListOFApps = fs.list("Star/Apps/")

    paintutils.drawFilledBox(1, 2, Settings.SizeOfLibarySideTab, MoniterY, colors.gray, colors.black)

    
    for k,v in pairs(ListOFApps) do
        term.setTextColor(colors.white)
        if v == AppSlected then
            term.setBackgroundColor(Settings.MainColor)
        else
            term.setBackgroundColor(colors.gray)
        end

        term.setCursorPos(2, (k * 2) + 2)
        term.write(TextCutOFF(ListOFApps[k],Settings.SizeOfLibarySideTab - 2, true))

        if v == AppSlected then
            DrawTextWithBoarder(TextCutOFF(ListOFApps[k],Settings.SizeOfLibarySideTab - 2, true),2, (k * 2) + 2,Settings.MainColor,colors.white,Settings.MainColor ,colors.gray, false)
        end
    end
    
    paintutils.drawBox(1, 2, Settings.SizeOfLibarySideTab, MoniterY, colors.black, colors.black)


end

local function LibaryMenu()
    DrawlibraryMenu()
    if AppSlected then
        DrawLibaryInfoPage()
    end
    DrawTabMenu()
    UpdateDoubleBuffer()
    local Event = {os.pullEvent()}
    if Event[1] == "mouse_click" then
        if Event[4] > 2 then
            if Event[3] > Settings.SizeOfLibarySideTab then
                --player is clicking on app info menu
                
                --looks if the player is clicking on play
                if Event[4] > 7 and Event[4] < 11 then
                    --play
                    LoadProgram(AppSlected)
                end
            else
                --player is clicking on app list
                local ListOFApps = fs.list("Star/Apps/")
                if ListOFApps[((Event[4] - 2 ) / 2)] then
                    if ListOFApps[((Event[4] - 2 ) / 2)] ~= nil then
                        if Event[2] == 1 then
                            --open settings thing
                            AppSlected = ListOFApps[((Event[4] - 2 ) / 2)]
                            print(AppSlected)
                            UpdateDoubleBuffer()

                        elseif Event[2] == 2 then
                            --open app
                            LoadProgram(ListOFApps[((Event[4] - 2 ) / 2)])
                        end
                    end
                end
            
            end
        else
            --player is clicking on tab menu
            if Event[3] < 2 then
            elseif Event[3] < 11 then
                MenuSelectioned = "library"
            elseif Event[3] < 20 then
                MenuSelectioned = "Profile"
            elseif Event[3] < 29 then
                MenuSelectioned = "Store"
            end
        end
    end
end





---------------------------------
--- Code todo with store page ---
---------------------------------


local StoreSelected = {
    Url = "https://raw.githubusercontent.com/Ai-Kiwi/Toaster/main/AppList",
    AppListCache = {}
}
--get storeselected data from website
local Website = http.get(StoreSelected.Url)
if Website then
    StoreSelected.AppListCache = textutils.unserialize(Website.readAll())
    Website.close()
end

local StoreAppSlected = nil

local function MainStorePageForApp()
    paintutils.drawFilledBox(Settings.SizeOfLibarySideTab + 1, 2, MoniterX, MoniterY, colors.gray, colors.gray)
    

    if StoreAppSlected then
        --draws background for title text
        paintutils.drawFilledBox(Settings.SizeOfLibarySideTab + 1, 2, MoniterX, 6, Settings.MainColor, colors.lightGray,"X")

        --draws big title text
        term.setCursorPos(Settings.SizeOfLibarySideTab + 3, 4)
        BigFont.bigPrint(StoreAppSlected.Name)
        --draws play butten
        DrawTextWithBoarder("Install",Settings.SizeOfLibarySideTab + 4, 9,Settings.MainColor,colors.white,Settings.MainColor ,colors.gray, false)
        
        
        --draw app description
        term.setCursorPos(Settings.SizeOfLibarySideTab + 4, 11)
        term.setTextColor(colors.white)
        local RowTextSize = MoniterX - (5 + Settings.SizeOfLibarySideTab)
        for i=1, MoniterY - 11 do
            term.setCursorPos(Settings.SizeOfLibarySideTab + 4, 11 + i)
            term.write(string.sub(StoreAppSlected.Desc, (i - 1) * RowTextSize, (i * RowTextSize) - 1))
        end

    end

    paintutils.drawBox(Settings.SizeOfLibarySideTab + 1, 2, MoniterX, MoniterY, colors.black, colors.black)
end

local function StoreMenu()

    --draw the list of all of the apps
    paintutils.drawFilledBox(1, 2, Settings.SizeOfLibarySideTab, MoniterY, colors.gray, colors.black)
    for k,v in pairs(StoreSelected.AppListCache) do
        --look if app is selected
        term.setTextColor(colors.white)
        if v == StoreAppSlected then
            term.setBackgroundColor(Settings.MainColor)
        else
            term.setBackgroundColor(colors.gray)
        end
        
        --goto app pos then draw
        term.setCursorPos(2, (k * 2) + 2)
        term.write(TextCutOFF(StoreSelected.AppListCache[k].Name,Settings.SizeOfLibarySideTab - 2, true))
        
        --if app is selected then draw it big so it has big outline
        if v == StoreAppSlected then
            DrawTextWithBoarder(TextCutOFF(StoreSelected.AppListCache[k].Name,Settings.SizeOfLibarySideTab - 2, true),2, (k * 2) + 2,Settings.MainColor,colors.white,Settings.MainColor ,colors.gray, false)
        end
    end
    paintutils.drawBox(1, 2, Settings.SizeOfLibarySideTab, MoniterY, colors.black, colors.black)
    MainStorePageForApp()
    DrawTabMenu()
    UpdateDoubleBuffer()

    local Event = {os.pullEvent()}
    if Event[1] == "mouse_click" then
        if Event[4] > 2 then
            if Event[3] > Settings.SizeOfLibarySideTab then
                --player is clicking on app page menu
                
                --looks if the player is clicking on install button
                if Event[4] > 7 and Event[4] < 14 then
                    fs.makeDir("Star/Apps/" .. StoreAppSlected.Name)


                    --downloads
                    local DataToSave = {
                        ["startup.lua"] = "shell.run(\"wget run " .. StoreAppSlected.DownloadUrl .. "\")"
                    }
                    local FileToSave = fs.open("Star/Apps/"..StoreAppSlected.Name.."/Data.vfs", "w")
                    FileToSave.write(textutils.serialize(DataToSave))
                    FileToSave.close()
                    
                    --saves verson installed
                    local FileToSave = fs.open("Star/Apps/"..StoreAppSlected.Name.."/info.data", "w")
                    DataToSave = {
                        ["Version"] = StoreAppSlected.VERSION
                    }
                    FileToSave.write(textutils.serialize(StoreAppSlected))
                    FileToSave.close()

                    MenuSelectioned = "library"
                end
            else
                --player is clicking on app list
                if StoreSelected.AppListCache[((Event[4] - 2 ) / 2)] then
                    if StoreSelected.AppListCache[((Event[4] - 2 ) / 2)] ~= nil then
                        if Event[2] == 1 then
                            --open settings thing
                            StoreAppSlected = StoreSelected.AppListCache[((Event[4] - 2 ) / 2)]


                        end
                    end
                end
            
            end
        else
            --player is clicking on tab menu
            if Event[3] < 2 then
            elseif Event[3] < 11 then
                MenuSelectioned = "library"
            elseif Event[3] < 20 then
                MenuSelectioned = "Profile"
            elseif Event[3] < 29 then
                MenuSelectioned = "Store"
            end
        end
    end

end



-----------------
--- main loop ---
-----------------

while true do
    term.setBackgroundColor(colors.gray)
    term.setTextColor(colors.black)
    term.clear()


    if MenuSelectioned == "library" then
        LibaryMenu()
    elseif MenuSelectioned == "Store" then
        StoreMenu()
    else
        MenuSelectioned = "library"
    end
end






