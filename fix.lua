--MUFFINN COMMUNITY--
local registered_ids = {
    134611, 120824, 239848, 
    475429, 356083, 753490, 
    774228, 506287, 305824,
    798124, 156249, 420724,
    774603

}

local options = { check_startsb = false, check_webhook_use = false }
local initial_teks = "Your Sb text here"
local teks = initial_teks
local count = 0
local sisacount = 0
local WORLD_NAME = ""
local gems = GetPlayerInfo().gems
local SpamDelay = 40
local counterMode = "up"

function CHECKBOX(B)
    return B and "1" or "0"
end

function log(str)
   LogToConsole("`0[`#Muffinn Sb`0]`o "..str)
end

function crd()
    SendPacket(2, "action|input\ntext|`0PROXY SB PREMIUM BY `#@Muffinn")
    Sleep(800)
end

function overlayText(text)
  var = {}
  var[0] = "OnTextOverlay"
  var[1] = "`0[`#Muffinn Sb`0]`o ".. text
  SendVariantList(var)
end

function removeColor(text)
    return text:gsub("`.", "")
end

function FormatNumber(num)
    return tostring(num):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

function sendWebhook(message)
    if not options.check_webhook_use then return end
    if not webhook_url or webhook_url == "" then
      log("Error: Webhook URL is not set")
      return
    end
    
    Sleep(1000)  -- 1 second delay before sending webhook
  
    local success, error = pcall(function()
        local waktuSekarang = os.date("%H:%M:%S")
        local ingfokan = math.abs(GetPlayerInfo().gems - gems)
        gems = GetPlayerInfo().gems
  
        local myData = [[
                    {
                    "embeds": [
                      {
                        "title": "Superbroadcast Premium",
                        "color": "]] ..math.random(1000000,9999999).. [[",
                        "fields": [
                          {
                            "name": "<:player:1203057110208876656> Player Name",
                            "value": "```]] .. removeColor(GetLocal().name) .. [[```",
                            "inline": false
                          },
                          {
                            "name": "<:world:1203057112595562628> Current World",
                            "value": "```]] .. GetWorld().name .. [[```",
                            "inline": true
                          },
                          {
                            "name": "<:gems:1203057115770650664> Gems Info",
                            "value": "```Current Gems : ]] .. FormatNumber(gems) .. [[\nGems Used : ]] .. FormatNumber(ingfokan) .. [[```",
                            "inline": true
                          },
                          {
                            "name": "<a:broadcast:1203650179866296340> Superbroadcast Send",
                            "value": "```]] .. message .. [[```",
                            "inline": false
                          }
                        ]
                      }
                    ],
                    "username": "𝐌𝐔𝐅𝐅𝐈𝐍𝐍 𝐂𝐎𝐌𝐌𝐔𝐍𝐈𝐓𝐘",
                    "avatar_url": "https://media.discordapp.net/attachments/1136847163905818636/1196094627372073041/MUFFINN_STORE_ICON.png?ex=65f6fa6d&is=65e4856d&hm=51bb58f88d7c0fac188ffe8d5181d63767f060e53a90d97d9f3bee0c9fea0286&format=webp&quality=lossless&",
                    "attachments": []
                    }
        ]]
        MakeRequest(webhook_url, "POST", {["Content-Type"] = "application/json"}, myData)
    end)
  
    if not success then
        log("Error sending webhook: " .. tostring(error))
    end
  end

function sendWebhookFinished(completionMessage)
  if not webhook_url or webhook_url == "" then
    log("Error: Webhook URL is not set")
    return
  end

  Sleep(1000)  -- 1 second delay before sending finished webhook

  local finishedEmbed = [[
      {
          "username": "𝐌𝐔𝐅𝐅𝐈𝐍𝐍 𝐂𝐎𝐌𝐌𝐔𝐍𝐈𝐓𝐘",
          "avatar_url": "https://media.discordapp.net/attachments/1136847163905818636/1196094627372073041/MUFFINN_STORE_ICON.png?ex=65edbfed&is=65db4aed&hm=405bfb4e8ff9ecc2eb3493d5ae6bd7e9ec2c0ef0f9ea87e536a90b2219bf8edd&format=webp&quality=lossless&",
          "embeds": [
              {
                  "title": "AUTO SB ADVANCE",
                  "color": "]] ..math.random(1000000,9999999).. [[",
                  "description": ">>> ]].. completionMessage ..[[",
                  "thumbnail": {
                      "url": "https://cdn.discordapp.com/emojis/1193136130774802472.gif?size=44&quality=lossless"
                  }
              }
          ]
      }
  ]]
  MakeRequest(webhook_url, "POST", {["Content-Type"] = "application/json"}, finishedEmbed)
end

function cleanSignText(str)
    local cleanedStr = str
    cleanedStr = string.gsub(cleanedStr, "Dr%.%s*", '')
    cleanedStr = string.gsub(cleanedStr, "%s*%[BOOST%]", '')
    cleanedStr = string.gsub(cleanedStr, "%(%d+%)", '')
    return cleanedStr
end

function startsb()
    if spamThread then
        KillThread(spamThread)
    end
    WORLD_NAME = string.upper(GetWorld().name)
    local total_sent = 0
    local initial_count = counterMode == "up" and 1 or SpamDelay
    count = initial_count

    spamThread = RunThread(function()
        while options.check_startsb do
            local currentWorld = GetWorld()
            if currentWorld == nil or currentWorld.name ~= WORLD_NAME then
                log("`0[`eBroadcast`0] Not in the correct world. Attempting to enter " .. WORLD_NAME)
                options.check_startsb = false  -- Pause SB
                SendPacket(3, "action|join_request\nname|" .. WORLD_NAME .. "\ninvitedWorld|0")
                Sleep(5000)  -- Wait for 5 seconds to allow world change
                local attempts = 0
                while (currentWorld == nil or currentWorld.name ~= WORLD_NAME) and attempts < 5 do
                    currentWorld = GetWorld()
                    Sleep(1000)
                    attempts = attempts + 1
                end
                if currentWorld and currentWorld.name == WORLD_NAME then
                    log("`0[`eBroadcast`0] Successfully entered " .. WORLD_NAME .. ". Resuming SB.")
                    options.check_startsb = true  -- Resume SB
                else
                    log("`0[`eBroadcast`0] Failed to enter " .. WORLD_NAME .. ". SB stopped.")
                    return
                end
            end

            if teks ~= "" then
                if (counterMode == "up" and count <= SpamDelay) or (counterMode == "down" and count > 0) then
                    overlayText("SB IN 3")
                    Sleep(1000)
                    overlayText("SB IN 2")
                    Sleep(1000)
                    overlayText("SB IN 1")
                    Sleep(1000)
                    pcall(function()
                        SendPacket(2, "action|input\ntext|/sb " .. teks)
                    end)
                    total_sent = total_sent + 1
                    Sleep(2000)
                    
                    -- Calculate end time based on SpamDelay
                    local end_time = os.time() + (SpamDelay * 90) -- 90 seconds per SB
                    local end_time_formatted = os.date("%H:%M", end_time)
                    
                    local status_message
                    if counterMode == "up" then
                        if SpamDelay >= 40 then
                            local hours = math.floor(SpamDelay / 40)
                            status_message = string.format("`^Super Broadcasts Send (megaphone) `bSB Count `0[`b%d`0/`b%d`0] `0(sb end in %d hour%s at %s`0) `##MuffinnProxy", 
                                count, SpamDelay, hours, hours > 1 and "s" or "", end_time_formatted)
                        else
                            local minutes = math.ceil(SpamDelay * 1.5)
                            status_message = string.format("`^Super Broadcasts Send (megaphone) `bSB Count `0[`b%d`0/`b%d`0] `0(sb end in %d minute%s at %s`0) `##MuffinnProxy", 
                                count, SpamDelay, minutes, minutes > 1 and "s" or "", end_time_formatted)
                        end
                    else
                        if SpamDelay >= 40 then
                            local hours = math.floor(SpamDelay / 40)
                            status_message = string.format("`^Super Broadcasts Send (megaphone) `bSB Remains `0[`b%d`0] `0(sb end in %d hour%s at %s`0) `##MuffinnProxy", 
                                count, hours, hours > 1 and "s" or "", end_time_formatted)
                        else
                            local minutes = math.ceil(SpamDelay * 1.5)
                            status_message = string.format("`^Super Broadcasts Send (megaphone) `bSB Remains `0[`b%d`0] `0(sb end in %d minute%s at %s`0) `##MuffinnProxy", 
                                count, minutes, minutes > 1 and "s" or "", end_time_formatted)
                        end
                    end
                    
                    pcall(function()
                        SendPacket(2, "action|input\ntext|/me " .. status_message)
                    end)
                    Sleep(3000)
                    local message = counterMode == "up" and ("SB sent " .. count .. " out of " .. SpamDelay) or ("SB Remains " .. count)
                    pcall(sendWebhook, message)
                    
                    if counterMode == "up" then
                        count = count + 1
                    else
                        count = count - 1
                    end
                    Sleep(90000)
                else
                    -- SB finished
                    options.check_startsb = false
                    break
                end
            else
                Sleep(1000)
            end
        end
        
        -- Finish up after the loop
        options.check_startsb = false
        log("`0[`eBroadcast`0] Superbroadcast `4Finished")
        Sleep(1000)
        SendPacket(2, "action|input\ntext|/me `^Super Broadcasts Done (megaphone) `bSB Count `0[`b" .. total_sent .. "`0] `##MuffinnProxy")
        local completionMessage = "Your SB is done, total SB sent: " .. total_sent
        pcall(sendWebhookFinished, completionMessage)

        -- Reset count and text
        count = initial_count
        teks = initial_teks
        log("`0[`eBroadcast`0] Count reset to " .. initial_count .. " and text reset to default")
    end)
end

function main()
function hook_1(varlist)
    if varlist[0]:find("OnConsoleMessage") then
        if varlist[1]:find("Spam detected!") then
        return true
        end
    end
    return false
end
AddHook("onvariant", "hook one", hook_1)
AddHook("onvariant", "mommy", function(var)
  if var[0] == "OnSDBroadcast" then
      overlayText("Succes Blocked `4SDB!")
      return true
   end
  return false
end)

    AddHook("onvariant", "sign_edit_hook", function(var)
        if var[0] == "OnDialogRequest" and var[1]:find("sign_edit") then
            local displayText = var[1]:match("display_text||(.-)|128|")
            if displayText then
                teks = cleanSignText(displayText)
                log("`0[`eBroadcast`0] Text Set : " ..displayText)
                if options.check_startsb then
                    startsb()
                end
            end
            return true
        end
        return false
    end)

    function ShowSbDialog()
        local varlist_command = {}
        varlist_command[0] = "OnDialogRequest"
        varlist_command[1] = [[
set_default_color|`o
add_label_with_icon|big|`0Set Your Super Broadcast here|left|2480|
add_spacer|small|
add_checkbox|EnableSb|`wStart Sb|]]..CHECKBOX(options.check_startsb)..[[|
add_checkbox|EnableWebhook|`wEnabled Webhook|]]..CHECKBOX(options.check_webhook_use)..[[|
add_text_input|SetCount|`#Counter Set :|]]..SpamDelay..[[|5|
add_smalltext|`9Note `0: Default interval is `#40 `0means 1 hours sb|
add_spacer|small|
add_textbox|`#Super Broadcast `0Text :|
add_smalltext|`0(Max 120 letters or you can wrench sign to copy automaticly)|
add_text_input|SetSbText||]]..teks..[[|120|
add_spacer|small|
text_scaling_string|jakhelperbdjsjn|
add_smalltext|`wCounter Mode Superbroadcast :|
add_checkicon|CounterUp|`0Counter Up|staticBlueFrame|484||]] .. (counterMode == "up" and "1" or "0") .. [[|
add_checkicon|CounterDown|`0Counter Down|staticBlueFrame|486||]] .. (counterMode == "down" and "1" or "0") .. [[|
add_checkicon||END_LIST|noflags|0||
add_quick_exit|
end_dialog|iprogram|Close|Update|
]]
        SendVariantList(varlist_command)
    end

    AddHook("OnSendPacket", "P", function(type, str)
        if str:find("/set") then
            if str:match("/set") then
                ShowSbDialog()
                return true
            end
        end
        if str:find("/startsb") then
            if str:match("/startsb") then
                startsb()
                return true
            end
        end
        if str:find("EnableSb|1") and not options.check_startsb then
            options.check_startsb = true
            startsb()
            log("`0[`eBroadcast`0] Superbroadcast `2Enabled")
        elseif str:find("EnableSb|0") and options.check_startsb then
            options.check_startsb = false
            if spamThread then
                KillThread(spamThread)
                spamThread = nil
            end
            log("`0[`eBroadcast`0] Superbroadcast `4Disabled")
        end
    	if str:find("CounterUp|1") then
        	counterMode = "up"
        	log("`0[`eBroadcast`0] Counter mode set to Up")
    	elseif str:find("CounterDown|1") then
        	counterMode = "down"
        	log("`0[`eBroadcast`0] Counter mode set to Down")
    	end
        if str:find("EnableWebhook|1") and not options.check_webhook_use then
            options.check_webhook_use = true
            log("`0[`eBroadcast`0] Webhook `2Enabled")
        elseif str:find("EnableWebhook|0") and options.check_webhook_use then
            options.check_webhook_use = false
            log("`0[`eBroadcast`0] Webhook `4Disabled")
        end
        local newDelay = str:match("SetCount|(%d+)")
        if newDelay and tonumber(newDelay) and tonumber(newDelay) ~= SpamDelay then
            SpamDelay = tonumber(newDelay)
        end
        local newText = str:match("SetSbText|(.-)|")
        if newText and newText ~= teks then
            teks = newText
        end
    end)
end

if not io or not os or not MakeRequest then
    log("Makesure turn on `2io, os, makerequest")
    return -- Menghentikan eksekusi skrip
end

local function is_registered_id(id)
    for _, registered_id in ipairs(registered_ids) do
        if id == registered_id then
            return true
        end
    end
    return false
end

local user_id = GetLocal().userid

if is_registered_id(user_id) then
log("Makesure you set webhook link, if u enable webhook")
log("Script active")
Sleep(100)
log("Do /set to setting sb")
crd()
Sleep(100)
main()
else
log("Uid not register, please contact @muffinncps on dc if u have purchase this script")
end
