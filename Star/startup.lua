--fancy boot thing
term.clear()
local MoniterX, MoniterY = term.getSize()

local Settings = {}
local function VerifySetting(setting,default)
    if Settings[setting] == nil then
        Settings[setting] = default
    end
end

local function LoadSetting()
    local SettingsFile = fs.open("Star/UserData/Settings.conf", "r")
    local SettingsValue = ""
    if SettingsFile == nil then
        SettingsValue = "{}"
    else
        SettingsValue = SettingsFile.readAll()
        SettingsFile.close()
    end
    return textutils.unserialize(SettingsValue)
end
local function SaveSettings()
    local SettingsFile = fs.open("Star/UserData/Settings.conf", "w")
    SettingsFile.write(textutils.serialize(Settings))
    SettingsFile.close()
end

print("1")
LoadSetting()
print("1")
--defines it all frist to make sure that if its not loadded then it will auto create it
VerifySetting("MainColor",colors.green)

SaveSettings()


local function DrawToastText(XPos,YPos,Text)
    --clears screen
    term.setTextColor(colors.white)
    term.setBackgroundColor(Settings.MainColor)
    term.clear()

    --draw a black box around icon
    WidthOfBox = math.floor(#Text / 2) + 1
    if WidthOfBox < 3 then
        WidthOfBox = 3
    end
    --paintutils.drawBox(XPos-WidthOfBox + 3,YPos-3,XPos+WidthOfBox + 5,YPos+8,colors.white)
    paintutils.drawFilledBox(XPos-WidthOfBox + 4,YPos-2,XPos+WidthOfBox + 4,YPos+7,colors.black)
    

    --draws icon
    --gets ram loc
    local ImageToLoad = "Star/Data/Logo.nfp"
    --random chance for it to blink
    if math.random(1,2) == 1 then
        ImageToLoad = "Star/Data/Logo_Face.nfp"
    end

    --loads image
    local LoadedImage = paintutils.loadImage(ImageToLoad)
    --draws image
    paintutils.drawImage(LoadedImage,XPos,YPos - 1)
    
    --setup for text
    term.setTextColor(colors.white)
    term.setBackgroundColor(colors.black)
    --draw text down bottem
    term.setCursorPos(XPos-math.floor(#Text / 2) + 4,YPos+6)
    term.setTextColor(colors.white)
    term.write(Text)

    
end

-- script to download https://gist.githubusercontent.com/MCJack123/e634347fe7a3025d19d9f7fcf7e01c24/raw/10feb1d0442ad222681fbd22718dd74becae0300/yellowbox.lua
--downloads the yellowbox.lua file from the internet
local function DownloadFile(URL,FILEPATH)
    local YellowBox = http.get(URL .. "?cb=" .. os.epoch("utc"))
    fs.delete(FILEPATH)
    local YellowBoxFile = fs.open(FILEPATH, "w")
    YellowBoxFile.write(YellowBox.readAll())
    YellowBoxFile.close()
    YellowBox.close()
end

--downloads
DrawToastText((MoniterX / 2) - 4,(MoniterY / 2) - 3,"Downloading YellowBox")
DownloadFile("https://gist.githubusercontent.com/MCJack123/e634347fe7a3025d19d9f7fcf7e01c24/raw/df2516c628ee0111f77802f0884f9b24920a76e2/yellowbox.lua","Star/libs/yellowbox.lua")
DrawToastText((MoniterX / 2) - 4,(MoniterY / 2) - 3,"Downloading bios")
DownloadFile("https://raw.githubusercontent.com/cc-tweaked/CC-Tweaked/v1.16.4-1.95.2/src/main/resources/data/computercraft/lua/bios.lua","Star/libs/bios.lua")
DrawToastText((MoniterX / 2) - 4,(MoniterY / 2) - 3,"Downloading BigFont")
DownloadFile("https://pastebin.com/raw/3LfWxRWh","Star/libs/bigfont.lua")

--updates the installed files
DrawToastText((MoniterX / 2) - 4,(MoniterY / 2) - 3,"Updating Main File")
DownloadFile("https://raw.githubusercontent.com/Ai-Kiwi/Star/main/Star/Main.lua","Star/Main.lua")
DrawToastText((MoniterX / 2) - 4,(MoniterY / 2) - 3,"Updating startup File")
DownloadFile("https://raw.githubusercontent.com/Ai-Kiwi/Star/main/Star/startup.lua","Star/startup.lua")
DrawToastText((MoniterX / 2) - 4,(MoniterY / 2) - 3,"Updating logo face File")
DownloadFile("https://raw.githubusercontent.com/Ai-Kiwi/Star/main/Star/Data/Logo_Face.nfp","Star/Data/Logo_Face.nfp")
DrawToastText((MoniterX / 2) - 4,(MoniterY / 2) - 3,"Updating logo File")
DownloadFile("https://raw.githubusercontent.com/Ai-Kiwi/Star/main/Star/Data/Logo.nfp","Star/Data/Logo.nfp")


shell.run("Star/Main.lua")

term.redirect(term.native())

DrawToastText((MoniterX / 2) - 4,(MoniterY / 2) - 3,"Whoops Star crapped its pants")
while true do
    os.sleep(1)
    os.reboot()
end
