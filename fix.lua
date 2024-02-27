--MUFFINN STORE--
local registered_ids = {134611, 120824, 239848, 475429}
local count = 0
local timer = 0

function removeColor(text)
    local cleanedStr = string.gsub(text, "`(%S)", '')
    cleanedStr = string.gsub(cleanedStr, "`{2}|(~{2})", '')
    return cleanedStr
end

removeColor(GetLocal().name)
-- Kirim webhook setelah superbroadcast dikirim
local myLink = URL --link webhook 
local gems = GetPlayerInfo().gems
local gemspent = GetPlayerInfo().gems
local teks = TextSB
local world = GetWorld().name

AddHook("onvariant", "mommy", function(var)
    if var[0] == "OnSDBroadcast" then
        return true
    end
end)

function crd()
    SendPacket(2, "action|input\ntext|`^SC SB PREMIUM `0[`^MUFFINN`0-`^STORE`0]")
    Sleep(800)
end

function UpdateCountAndTime(isCount, isIncrease)
    if isCount then
        if isIncrease then
            count = count + 1
        else
            count = count - 1
        end
    else
        if isIncrease then
            timer = timer + 1.5
        else
            timer = timer - 1.5
        end
    end
end

function GenerateEmbedData()
    local countText
    local countValue
    local waktuSekarang = os.date("%H:%M:%S")

    if CONFIGURATION.display_mode == "sb_count" then
        countText = "Status Broadcast"
        if CONFIGURATION.mode_sb == "countup" then
            countValue = "SB Send : " .. count .. " out of total SB : " .. JumlahSB
        elseif CONFIGURATION.mode_sb == "countdown" then
            countValue = count .. " SB left"
        elseif CONFIGURATION.mode_sb == "timerup" then
            countValue = string.format("%.1f", timers - timer) .. " Min of " .. timers .. " Min"
        elseif CONFIGURATION.mode_sb == "timerdown" then
            countValue = string.format("%.1f", timer) .. " Min left"
        end
    elseif CONFIGURATION.display_mode == "timer_count" then
        countText = "Status Broadcast"
        if CONFIGURATION.mode_sb == "countup" then
            countValue = "SB Send : " .. count .. " out of total SB : " .. JumlahSB
        elseif CONFIGURATION.mode_sb == "countdown" then
            countValue = count .. " SB left"
        elseif CONFIGURATION.mode_sb == "timerup" then
            countValue = string.format("%.1f", timers - timer) .. " Min of " .. timers .. " Min"
        elseif CONFIGURATION.mode_sb == "timerdown" then
            countValue = string.format("%.1f", timer) .. " Min left"
        end
    end

    local myData = [[
        {
            "embeds": [
                {
                    "title": "PREMIUM SB BY MUFFINN",
                    "color": 0,
                    "fields": [
                        {
                            "name": "<:player:1203057110208876656> Player",
                            "value": ">>> ]]..removeColor(GetLocal().name) ..[[",
                            "inline": true
                        },
                        {
                            "name": "<:world:1203057112595562628> World",
                            "value": ">>> ]].. GetWorld().name ..[[",
                            "inline": true
                        },
                        {
                            "name": "<:gems:1203057115770650664> Gems",
                            "value": ">>> ]].. gems ..[[",
                            "inline": true
                        },
                        {
                            "name": "<a:broadcast:1203650179866296340> ]].. countText ..[[",
                            "value": ">>> ]].. countValue ..[[",
                            "inline": true
                        },
                        {
                            "name": "<a:time:1203650182164512769> Time",
                            "value": ">>> ]].. waktuSekarang ..[[",
                            "inline": false
                        },
                        {
                            "name": ":bookmark_tabs: Teks Sb",
                            "value": ">>> ]].. removeColor(teks) ..[[",
                            "inline": false
                        }
                    ]
                }
            ]
        }
    ]]
    return myData
end

function SendWebhook(url, data)
    MakeRequest(url,"POST",{["Content-Type"] = "application/json"},data)
end

function super()
    local sisaCount = 0
    local sisaTimer = 0

    if CONFIGURATION.mode_sb == "countup" then
        while count < JumlahSB do
            SendPacket(2, "action|input\ntext|/sb " .. TextSB)
            UpdateCountAndTime(true, true)
            sisaCount = JumlahSB - count
            Sleep(1000)
            SendPacket(2, "action|input\ntext|/me `^Super Broadcasts Send (megaphone) `bSB Count `0[`b" .. count .. "`0/`b" .. JumlahSB .. "`0] `bRemains `0[`b" .. sisaCount .."`0]")
            local myData = GenerateEmbedData()
            SendWebhook(myLink, myData)
            Sleep(90000)
        end
    elseif CONFIGURATION.mode_sb == "countdown" then
        count = JumlahSB
        while count > 0 do
            SendPacket(2, "action|input\ntext|/sb " .. TextSB)
            UpdateCountAndTime(true, false)
            Sleep(1000)
            SendPacket(2, "action|input\ntext|/me `^Super Broadcasts Send (megaphone) `bSB Remaining `0[`b" .. count .. " `2Left`0]")
            local myData = GenerateEmbedData()
            SendWebhook(myLink, myData)
            Sleep(90000)
        end
    elseif CONFIGURATION.mode_sb == "timerup" then
        while timer < timers do
            SendPacket(2, "action|input\ntext|/sb " .. TextSB)
            UpdateCountAndTime(false, true)
            sisaTimer = timers - timer
            Sleep(1000)
            SendPacket(2, "action|input\ntext|/me `^Super Broadcasts Send (megaphone) `bTime Remaining `0: `b" .. sisaTimer .. " `8Minutes `0OF`b " .. timers .. " `8Minutes")
            local myData = GenerateEmbedData()
            SendWebhook(myLink, myData)
            Sleep(90000)
        end
    elseif CONFIGURATION.mode_sb == "timerdown" then
        timer = timers
        while timer > 0 do
            SendPacket(2, "action|input\ntext|/sb " .. TextSB)
            UpdateCountAndTime(false, false)
            Sleep(1000)
            SendPacket(2, "action|input\ntext|/me `^Super Broadcasts Send (megaphone) `bTime Remaining `0: `b[`0" .. timer .. " `2Minutes Left`b]")
            local myData = GenerateEmbedData()
            SendWebhook(myLink, myData)
            Sleep(90000)
        end
    end

function sendWebhookSuperFinished()
local currentTime = os.date("%H:%M:%S")
local finishedMessage = "Superbroadcast mu telah selesai. Dengan Jumlah Sb: " .. JumlahSB -- Ubah JumlahSB sesuai kebutuhan Anda
   if CONFIGURATION.display_mode == "timer_count" then
         finishedMessage = "Superbroadcast mu telah selesai. Dengan Jumlah Waktu Sb : " .. timers .. " menit" -- Ubah timers sesuai kebutuhan Anda
 end

local finishedEmbed = [[
    {
        "embeds": [
            {
                "title": "PREMIUM SB BY MUFFINN",
                "color": 0,
                "description": ">>> ]].. finishedMessage ..[[ \nSuperbroadcast mu selesai pada ]].. currentTime ..[[",
                "thumbnail": {
                    "url": "https://cdn.discordapp.com/emojis/1193136130774802472.gif?size=44&quality=lossless"
                }
            }
        ]
    }
]]
SendWebhook(myLink, finishedEmbed)
end

if count >= JumlahSB or count == 0 or timer >= timers or timer == 0 then
        SendPacket(2, "action|input\ntext|" .. GetLocal().name .. " `bSuper Broadcasts `8Done!!")
        sendWebhookSuperFinished()
    end
end

-- Pemeriksaan IO, OS, dan MakeRequest
if not io or not os or not MakeRequest then
    LogToConsole("`^Mohon aktifkan IO, OS, dan MakeRequest untuk menggunakan skrip ini.")
    return -- Menghentikan eksekusi skrip
end

-- Fungsi untuk memeriksa apakah ID pengguna terdaftar
local function is_registered_id(id)
    for _, registered_id in ipairs(registered_ids) do
        if id == registered_id then
            return true
        end
    end
    return false
end

-- Mendapatkan ID pengguna lokal
local user_id = GetLocal().userid

-- Memeriksa apakah ID pengguna terdaftar
if is_registered_id(user_id) then
    LogToConsole("`0[`^MUFFINN`0-`^STORE`0]`^: IDENTIFIED PLAYER : " .. GetLocal().name)
    Sleep(1000)
    LogToConsole("`0[`^MUFFINN`0-`^STORE`0]`^: WAIT CHECK UID")
    Sleep(1000)
    LogToConsole("`0[`^MUFFINN`0-`^STORE`0]`^: UID TERDAFTAR")
    Sleep(1000)
    LogToConsole("`0[`^MUFFINN`0-`^STORE`0]`^: STARTING SC SB PREMIUM")
    Sleep(1000)
    crd()
    Sleep(1000)
    super()
else
    LogToConsole("`0[`^MUFFINN`0-`^STORE`0]`^: IDENTIFIED PLAYER : " .. GetLocal().name)
    Sleep(1000)
    LogToConsole("`0[`^MUFFINN`0-`^STORE`0]`^: WAIT CHECK UID")
    Sleep(1000)
    LogToConsole("`0[`^MUFFINN`0-`^STORE`0]`^: UID TIDAK TERDAFTAR KONTAK DISCORD @muffinncps")
end
