term.setBackgroundColor(colors.blue)
term.setTextColor(colors.white)
term.clear()

term.setCursorPos(2,2)
print("Star Installer")

term.setCursorPos(2,5)
print("please click to continue")

local function FancyButten(x,y,Text)
    term.setBackgroundColor(colors.blue)
    term.setTextColor(colors.white)
    term.setCursorPos(x - 1,y + 1)
    --draw bottom left
    term.write("\130")
    --draw bottom
    for i=1,#Text do
        term.write("\131")
    end
    --draw bottom right
    term.write("\129")

    term.setCursorPos(x + #Text,y)
    --draw right
    term.write("\149")

    --draw top right
    term.setCursorPos(x + #Text,y - 1)
    term.write("\144")

    
    term.setBackgroundColor(colors.white)
    term.setTextColor(colors.blue)

    term.setCursorPos(x - 1,y)
    --draw left
    term.write("\149")

    term.setCursorPos(x - 1,y - 1)
    --draw top left
    term.write("\159")
    --draw top
    for i=1,#Text do
        term.write("\143")
    end

    term.setCursorPos(x,y)
    term.setBackgroundColor(colors.white)
    term.setTextColor(colors.blue)
    term.write(Text)
    
end

local function PosToDrawBox(x,y,Enabled)
    term.setBackgroundColor(colors.blue)
    term.setTextColor(colors.white)
    term.setCursorPos(x - 1,y + 1)
    --draw bottom left
    term.write("\130")
    --draw bottom
    term.write("\131")
    --draw bottom right
    term.write("\129")

    term.setCursorPos(x + 1,y)
    --draw right
    term.write("\149")

    --draw top right
    term.setCursorPos(x + 1,y - 1)
    term.write("\144")

    --draw the top
    term.setBackgroundColor(colors.white)
    term.setTextColor(colors.blue)

    term.setCursorPos(x - 1,y)
    --draw left
    term.write("\149")

    term.setCursorPos(x - 1,y - 1)
    --draw top left
    term.write("\159")
    --draw top
    term.write("\143")

    term.setCursorPos(x,y)
    term.setBackgroundColor(colors.blue)
    term.setTextColor(colors.white)
    if Enabled then
        term.write("x")
    else
        term.write(" ")
    end
    
end

local settings = {}
settings[1] = {
    name = "Install Auto Start Script",
    State = true,
    Type = "bool",
}
settings[2] = {
    name = "Default Color",
    State = 32,
    Type = "color",
}

local function DownloadFile(URL,FILEPATH)
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    print("getting website " .. URL)
    local Website = http.get(URL .. "?cb=" .. os.epoch("utc"))
    print("clearing " .. FILEPATH)
    fs.delete(FILEPATH)
    print("opening file " .. FILEPATH)
    local File = fs.open(FILEPATH, "w")
    print("writing file " .. FILEPATH)
    File.write(Website.readAll())
    print("closing file " .. FILEPATH)
    File.close()
    print("closing website " .. URL)
    Website.close()
end

while true do 
    local event, button, x, y = os.pullEvent("mouse_click")
    term.setBackgroundColor(colors.blue)
    term.setTextColor(colors.white)
    term.clear()

    term.setCursorPos(2,2)
    print("Star Installer")


    for i = 1, #settings do
        if settings[i].Type == "bool" then
            if y == ((i * 3) + 2) and x == 2 then 
                settings[i].State = not settings[i].State
            end
            term.setCursorPos(4,(i * 3) + 2)
            term.write(settings[i].name)
            PosToDrawBox(2,(i * 3) + 2,settings[i].State)
        elseif settings[i].Type == "color" then
            if y == ((i * 3) + 2) and x == 2 then 
                settings[i].State = settings[i].State * 2
                if settings[i].State == 65536 then
                    settings[i].State = 1
                end
            end
            term.setCursorPos(4,(i * 3) + 2)
            term.write(settings[i].name)
            PosToDrawBox(2,(i * 3) + 2,false)
            term.setCursorPos(2,(i * 3) + 2)
            term.setBackgroundColor(settings[i].State)
            term.setTextColor(colors.white)
            term.write(" ")
            
            

        end


    end

    if y == (#settings * 3) + 5 and x > 2 and x < 9 then
        term.setBackgroundColor(colors.black)
        term.setTextColor(colors.white)
        term.clear()
        term.setCursorPos(1,1)
        --download auto start hook
        if settings[1].State then
            DownloadFile("https://raw.githubusercontent.com/Ai-Kiwi/Star/main/startup.lua", "startup.lua")
        end
        print("updating settings file")
        --download default color
        local file = fs.open("Star/UserData/settings.conf", "w")
        local FileToSave = {}
        FileToSave["MainColor"] = settings[2].State
        file.write(textutils.serialize(FileToSave))
        file.close()

        
        --downloads
        DownloadFile("https://gist.githubusercontent.com/MCJack123/e634347fe7a3025d19d9f7fcf7e01c24/raw/df2516c628ee0111f77802f0884f9b24920a76e2/yellowbox.lua","Star/libs/yellowbox.lua")
        DownloadFile("https://raw.githubusercontent.com/cc-tweaked/CC-Tweaked/v1.16.4-1.95.2/src/main/resources/data/computercraft/lua/bios.lua","Star/libs/bios.lua")
        DownloadFile("https://pastebin.com/raw/3LfWxRWh","Star/libs/bigfont.lua")

        --updates the installed files
        DownloadFile("https://raw.githubusercontent.com/Ai-Kiwi/Star/main/Star/Main.lua","Star/Main.lua")
        DownloadFile("https://raw.githubusercontent.com/Ai-Kiwi/Star/main/Star/startup.lua","Star/startup.lua")
        DownloadFile("https://raw.githubusercontent.com/Ai-Kiwi/Star/main/Star/Data/Logo_Face.nfp","Star/Data/Logo_Face.nfp")
        DownloadFile("https://raw.githubusercontent.com/Ai-Kiwi/Star/main/Star/Data/Logo.nfp","Star/Data/Logo.nfp")
       
        fs.makeDir("Star/Apps")
       
        os.reboot()
    end
    FancyButten(2,(#settings * 3) + 5,"Install")

end

term.setCursorPos(10,10)
