-- ====================================================================
-- 👑 AXER CHAT : THE APEX TITAN EDITION (FINAL MASTER-CORE V28.0)
-- DEV : VENUS_EDIT
-- All 22+ Security Vectors Hardened & Intact
-- UNIVERSAL : 100% Compatible with Delta, Solara, Codex, MacSploit, Fluxus
-- FIX 1 : ANTI-SPOOF NAME FETCH - Bypasses executor local spoofing
-- FIX 2 : FORBID ANNIHILATOR - Auto-burns FORBID, f0rb1d, f0rbid, etc.
-- FIX 3 : Absolute Thread-Halt Crash Loop (Banned users freeze instantly)
-- FIX 4 : Auto-Infect HWID Mesh Engine (Cross-device Ban propagation)
-- FIX 5 : Strict 200 Characters Limit + Anti-Spam + ARIA Warnings
-- 🔥 FIREBASE INTEGRATION : Server-only sync (replaces proxy for main chat)
-- 🔥 FIREBASE URL (Server Chat) : https://axer-rechat-default-rtdb.asia-southeast1.firebasedatabase.app/
-- 🖼️ ARIA PIC : rbxassetid://92917449577250
-- 🎵 INTRO AUDIO : https://files.catbox.moe/4vcrq5.mp3
-- 🎵 ADMIN JOIN AUDIO : https://files.catbox.moe/7aqtw5.mp4 (plays 2 sec before join msg)
-- 🖼️ MINIMIZER LOGO : rbxassetid://106542899596174 (Updated)
-- 💬 BUBBLES : Theme-aware (Dark/Light/Glass) with no forced white
-- 👑 ADMIN JOIN BANNER : ARIA says in chat when VENUS_EDIT joins (once per server)
-- 💬 ANNOUNCEMENT SYSTEM REMOVED – only server chat and admin join remain
-- ====================================================================

if getgenv().AxerChat_Loaded then
	getgenv().AxerChat_Unloading = true
	task.wait(0.3)
	pcall(function()
		local cgui = pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
		for _, v in pairs(cgui:GetChildren()) do if v.Name:match("^AxerUI_") then v:Destroy() end end
	end)
end
getgenv().AxerChat_Loaded = true; getgenv().AxerChat_Unloading = false

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserService = pcall(function() return game:GetService("UserService") end) and game:GetService("UserService") or nil
local LocalPlayer = Players.LocalPlayer

local CoreGui = pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui") or nil

-- [ 🌐 UNIVERSAL EXECUTOR HTTP PIPELINE RESOLVER ]
local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or (getgenv().request) or request
if not httprequest then warn("AXER CHAT: HTTP Request pipeline missing!") return end

-- ====================================================================
--  🔥 FIREBASE REALTIME DATABASE SYNC (Server‑only)
-- ====================================================================
local FIREBASE_URL = "https://axer-rechat-default-rtdb.asia-southeast1.firebasedatabase.app/"
local FIREBASE_SERVER_PATH = "servers/" .. game.JobId .. "/chat.json"

local function makeHttpRequest(options)
    local req = (syn and syn.request) or http_request or request or (http and http.request)
    if req then
        local success, response = pcall(req, options)
        if success then return response end
    end
    return nil
end

-- Broadcast a message to Firebase (server channel)
local function BroadcastToFirebase(sender, text, isImg, imgUrl)
    if FIREBASE_URL == "https://YOUR-PROJECT-ID-default-rtdb.firebaseio.com/" then return end
    task.spawn(function()
        local data = {
            sender = sender,
            displayName = LocalPlayer.DisplayName,
            text = text,
            isImg = isImg or false,
            imgUrl = imgUrl or "",
            timestamp = os.time()
        }
        local success, json = pcall(function() return HttpService:JSONEncode(data) end)
        if success then
            makeHttpRequest({
                Url = FIREBASE_URL .. FIREBASE_SERVER_PATH,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = json
            })
        end
    end)
end

-- [ 👑 ADMIN JOIN BROADCAST - ARIA will say it in chat (only once per server) ]
local function BroadcastAdminJoin()
    if FIREBASE_URL == "https://YOUR-PROJECT-ID-default-rtdb.firebaseio.com/" then return end
    -- Check if already announced for this server
    local flagFile = "AxerAdminJoin_" .. game.JobId .. ".txt"
    if isfile and isfile(flagFile) then return end  -- already done

    task.spawn(function()
        local joinMessage = "👑 SUPREME LEADER AND CREATOR OF AXER CHAT SIR AXER HAS JOINED 👑"
        local data = {
            sender = "ARIA",
            displayName = "ARIA",
            text = joinMessage,
            isImg = false,
            isSystem = true,
            isAdminJoin = true,
            imgUrl = "",
            timestamp = os.time()
        }
        local success, json = pcall(function() return HttpService:JSONEncode(data) end)
        if success then
            makeHttpRequest({
                Url = FIREBASE_URL .. FIREBASE_SERVER_PATH,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = json
            })
            -- Mark as done for this server
            if writefile then
                pcall(function() writefile(flagFile, "1") end)
            end
        end
    end)
end

-- ====================================================================

local function GenerateRandomUIName() local s="AxerUI_"; for _=1,12 do s=s..string.char(math.random(65,90)) end return s end
local c_wrap = (typeof(newcclosure) == "function" and newcclosure) or function(f) return f end

-- [ 🛡️ BULLETPROOF MULTI-LAYER UNIVERSAL HWID GENERATOR ]
local function GetBulletproofHWID()
	local h = ""
	pcall(function() h = gethwid() end)
	if not h or h == "" then pcall(function() h = getgenv().gethwid() end) end
	if not h or h == "" then pcall(function() h = game:GetService("RbxAnalyticsService"):GetClientId() end) end
	if not h or h == "" then h = "FALLBACK_ID_" .. tostring(LocalPlayer.UserId) end
	return tostring(h):gsub("[^%w_]", "")
end
local MY_HWID = GetBulletproofHWID()
local EXECUTOR_NAME = (identifyexecutor and identifyexecutor()) or "Unknown_Universal_Exec"

-- [ 🌐 STATIC PROXY RESOLVER (kept for DMs & admin) ]
local proxy_bytes = {104, 116, 116, 112, 115, 58, 47, 47, 122, 97, 121, 110, 45, 112, 114, 111, 120, 121, 46, 99, 108, 105, 112, 105, 102, 121, 105, 110, 100, 105, 97, 48, 46, 119, 111, 114, 107, 101, 114, 115, 46, 100, 101, 118, 47}
local STATIC_PROXY = ""
for _, b in ipairs(proxy_bytes) do STATIC_PROXY = STATIC_PROXY .. string.char(b) end
local getSalt = c_wrap(function() return "5A40796E5F4D40737465725F4B33795F39393831325F47686F73745F50726F746F636F6C5F585F53757072656D655F56313831" end)
local getSrvPfx = c_wrap(function() return "AxerSrvSec_Key_" end)
local rawJob = (game.JobId ~= "") and game.JobId or "OFFLINE_STUDIO_TEST_99"
local REAL_JOB_ID = rawJob:gsub("[^%w_]", "") 

-- [ 💀 CRASH ENGINE ]
local function PunishBannedUser()
	task.spawn(function()
		pcall(function()
			local cg = pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
			for _,v in pairs(cg:GetChildren()) do if v.Name:find("Axer") then v:Destroy() end end
		end)
	end)
	LocalPlayer:Kick("\n⛔ APEX TITAN BAN ENGINE ⛔\nAccount or Device Fingerprint permanently blacklisted by VENUS_EDIT.")
	task.wait(0.5)
	task.spawn(function() while true do end end) -- INSTANT CRASH LOOP
	while true do task.wait(9e9) end -- THREAD HALT
end

-- [ 🛑 ABSOLUTE THREAD-HALTING BAN ENGINE (BYPASS PROOF) ]
local function ExecuteAbsoluteBanCheck()
	local usrLower = LocalPlayer.Name:lower()
	local isLocallyBanned = false

	if pcall(isfile, "AxerTitan_Ban_Signature.sys") and isfile("AxerTitan_Ban_Signature.sys") then isLocallyBanned = true end

	local s1, b1 = pcall(function() return httprequest({Url = STATIC_PROXY .. "ZaynMasterFinal/Blacklist/Accounts/" .. usrLower .. ".json?bust="..tostring(os.clock()), Method = "GET"}).Body end)
	local s2, b2 = pcall(function() return httprequest({Url = STATIC_PROXY .. "ZaynMasterFinal/Blacklist/HWIDs/" .. MY_HWID .. ".json?bust="..tostring(os.clock()), Method = "GET"}).Body end)

	local isCloudBanned = false
	if (s1 and b1 and string.find(b1, "true")) or (s2 and b2 and string.find(b2, "true")) then isCloudBanned = true end

	if isCloudBanned then
		task.spawn(function()
			pcall(function() if writefile then writefile("AxerTitan_Ban_Signature.sys", "PERMA_BANNED_BY_VENUS_EDIT") end end)
			httprequest({Url = STATIC_PROXY .. "ZaynMasterFinal/Blacklist/HWIDs/" .. MY_HWID .. ".json", Method = "PUT", Body = "true"})
			httprequest({Url = STATIC_PROXY .. "ZaynMasterFinal/Blacklist/Accounts/" .. usrLower .. ".json", Method = "PUT", Body = HttpService:JSONEncode(MY_HWID)})
		end)
		PunishBannedUser()
	elseif isLocallyBanned and not isCloudBanned then
		pcall(function() if delfile then delfile("AxerTitan_Ban_Signature.sys") end end)
	end
end
ExecuteAbsoluteBanCheck()

-- [ 🕵️ ANTI-SPOOF & 'FORBID' ANNIHILATOR ENGINE ]
local function PerformStrictIdentityCheck()
	local realName = LocalPlayer.Name
	local realDisplayName = LocalPlayer.DisplayName
	
	pcall(function()
		local success, nameResult = pcall(function() return Players:GetNameFromUserIdAsync(LocalPlayer.UserId) end)
		if success and nameResult then realName = nameResult end
		
		if UserService then
			local s2, info = pcall(function() return UserService:GetUserInfosByUserIdsAsync({LocalPlayer.UserId})[1] end)
			if s2 and info then 
				if info.Username then realName = info.Username end
				if info.DisplayName then realDisplayName = info.DisplayName end
			end
		end
	end)

	local function checkForbidden(str)
		if not str then return false end
		local normalized = str:lower():gsub("0", "o"):gsub("1", "i")
		return string.find(normalized, "forbid") ~= nil
	end

	if checkForbidden(realName) or checkForbidden(realDisplayName) then
		task.spawn(function()
			pcall(function() if writefile then writefile("AxerTitan_Ban_Signature.sys", "PERMA_BANNED_FORBID_CLAN") end end)
			httprequest({Url = STATIC_PROXY .. "ZaynMasterFinal/Blacklist/HWIDs/" .. MY_HWID .. ".json", Method = "PUT", Body = "true"})
			httprequest({Url = STATIC_PROXY .. "ZaynMasterFinal/Blacklist/Accounts/" .. realName:lower() .. ".json", Method = "PUT", Body = HttpService:JSONEncode(MY_HWID)})
		end)
		PunishBannedUser()
	end
end
PerformStrictIdentityCheck()

-- [ 💀 HARDCODED PRE-CHECK BANLIST ]
local AXER_HARDCODED_BANLIST = { UserIds = { ["baduser123"] = true }, HWIDs = { ["ADD_HWID_HERE"] = true } }
if AXER_HARDCODED_BANLIST.UserIds[LocalPlayer.Name:lower()] or AXER_HARDCODED_BANLIST.HWIDs[MY_HWID] then LocalPlayer:Kick("\n⛔ PERMANENT BAN ⛔\nMachine strictly blacklisted."); task.spawn(function() while true do end end); while true do task.wait(9e9) end end

-- [ 🚨 TITANGUARD V28.0 ]
local function TitanGuardKick(code, reason)
	if getgenv().AxerChat_Unloading then return end
	
	local severe_codes = { ["SPY-01"]=true, ["TRP-M01"]=true, ["TRP-W02"]=true, ["META-HOOK"]=true, ["VIP-SPOOF"]=true, ["GOD-BREACH"]=true }
	if severe_codes[code] then
		task.spawn(function()
			httprequest({Url = STATIC_PROXY .. "ZaynMasterFinal/Blacklist/HWIDs/" .. MY_HWID .. ".json", Method = "PUT", Body = "true"})
			httprequest({Url = STATIC_PROXY .. "ZaynMasterFinal/Blacklist/Accounts/" .. LocalPlayer.Name:lower() .. ".json", Method = "PUT", Body = HttpService:JSONEncode(MY_HWID)})
			pcall(function() if writefile then writefile("AxerTitan_Ban_Signature.sys", "PERMA_BANNED_BY_TITANGUARD") end end)
		end)
	end

	task.spawn(function()
		pcall(function()
			local logData = { PlayerName = LocalPlayer.Name, PlayerID = LocalPlayer.UserId, HWID = MY_HWID, Executor = EXECUTOR_NAME, ViolationCode = code, Reason = reason, ServerJobId = REAL_JOB_ID, Timestamp = os.time() }
			httprequest({ Url = STATIC_PROXY .. "AdminSecurityLogs/" .. LocalPlayer.Name:lower() .. "_" .. os.time() .. ".json", Method = "PUT", Headers = { ["Content-Type"] = "application/json" }, Body = HttpService:JSONEncode(logData) })
		end)
	end)
	task.wait(0.5); LocalPlayer:Kick("\n🛡️ AXER TITANGUARD 🛡️\nIntercepted Violation: [" .. code .. "]\nSession securely closed."); task.spawn(function() while true do end end); while true do task.wait(9e9) end
end

-- [ 👑 MULTI-ADMIN SYSTEM ]
local ADMIN_IDS = {
    7169032620,   -- VENUS_EDIT
}

local function IsStrictAdmin()
    local rp = LocalPlayer
    if rp.UserId == 7169032620 and string.lower(rp.Name) == "venus_edit" then
        return true
    end
    for _, id in ipairs(ADMIN_IDS) do
        if rp.UserId == id then
            return true
        end
    end
    return false
end
if LocalPlayer.UserId == 7169032620 and not IsStrictAdmin() then TitanGuardKick("VIP-SPOOF", "Identity Theft Intercepted") end

task.spawn(function() while task.wait(1.0) do if getthreadidentity and pcall(getthreadidentity) and getthreadidentity() < 7 and not getgenv().AxerChat_Unloading then TitanGuardKick("THREAD-HIJACK", "Privilege Downgrade Exploit") end end end)

-- [ 🎵 INTRO SOUND ]
task.spawn(function()
	local audioUrl = "https://files.catbox.moe/4vcrq5.mp3"; local fileName = "AxerIntroSound.mp3"
	if not isfile(fileName) then local succ, rawAudio = pcall(function() return httprequest({Url = audioUrl, Method = "GET"}).Body end); if succ and rawAudio and rawAudio ~= "" then writefile(fileName, rawAudio) end end
	pcall(function() local customAsset = getcustomasset(fileName); if customAsset then local sound = Instance.new("Sound"); sound.SoundId = customAsset; sound.Parent = CoreGui or game:GetService("CoreGui"); sound.Volume = 2.5; sound:Play(); sound.Ended:Connect(function() sound:Destroy() end) end end)
end)

-- [ 🎵 ADMIN JOIN AUDIO - plays 2 seconds before ARIA says the join message ]
local function PlayAdminJoinAudio()
    task.spawn(function()
        local audioUrl = "https://files.catbox.moe/7aqtw5.mp4"
        local fileName = "AxerAdminJoinAudio.mp4"
        if not isfile(fileName) then
            local succ, rawAudio = pcall(function() return httprequest({Url = audioUrl, Method = "GET"}).Body end)
            if succ and rawAudio and rawAudio ~= "" then
                pcall(function() writefile(fileName, rawAudio) end)
            end
        end
        pcall(function()
            local customAsset = getcustomasset(fileName)
            if customAsset then
                local sound = Instance.new("Sound")
                sound.SoundId = customAsset
                sound.Parent = CoreGui or game:GetService("CoreGui")
                sound.Volume = 3
                sound:Play()
                sound.Ended:Connect(function() sound:Destroy() end)
            end
        end)
    end)
end

task.spawn(function()
	if game.PlaceId ~= 4924922222 then return end
	local rs = game:GetService("ReplicatedStorage"); local RE = rs:FindFirstChild("RE") or rs
	task.spawn(function() while task.wait(0.06) do if getgenv().AxerChat_Unloading then break end local smoothHue = (os.clock() * 0.12) % 1; local premCol = Color3.fromHSV(smoothHue, 0.55, 1); pcall(function() local cr = RE:FindFirstChild("1RPNam1eColo1r"); if cr then cr:FireServer("PickingRPNameColor", premCol); cr:FireServer("PickingRPBioColor", premCol) end end) end end)
	local function FulfillRP() local ntr = RE:FindFirstChild("1RPNam1eTex1t"); if ntr then pcall(function() ntr:FireServer("RolePlayName", "ᴀxᴇʀ ♥ ᴄʜᴀᴛ"); ntr:FireServer("RolePlayBio", 'Welcome Dear "' .. LocalPlayer.DisplayName .. '"') end) end end
	FulfillRP(); LocalPlayer.CharacterAdded:Connect(function() task.wait(1.5); FulfillRP() end)
end)

local function AttachUniversalOverhead(char)
	if game.PlaceId == 4924922222 then return end
	local head = char:WaitForChild("Head", 5); if not head or head:FindFirstChild("AxerUniversalOverhead") then return end
	local b = Instance.new("BillboardGui", head); b.Name = "AxerUniversalOverhead"; b.Size = UDim2.new(0,220,0,45); b.StudsOffset = Vector3.new(0,3.2,0); b.AlwaysOnTop = true
	local title = Instance.new("TextLabel", b); title.Size = UDim2.new(1,0,0.55,0); title.BackgroundTransparency = 1; title.Text = "ᴀxᴇʀ ♥ ᴄʜᴀᴛ"; title.Font = Enum.Font.GothamBold; title.TextSize = 14; title.TextStrokeTransparency = 0
	local bio = Instance.new("TextLabel", b); bio.Size = UDim2.new(1,0,0.45,0); bio.Position = UDim2.new(0,0,0.55,0); bio.BackgroundTransparency = 1; bio.Text = 'Welcome dear "' .. LocalPlayer.DisplayName .. '"!'; bio.Font = Enum.Font.GothamMedium; bio.TextSize = 11; bio.TextColor3 = Color3.fromRGB(230,230,235)
	task.spawn(function() while b and b.Parent do if getgenv().AxerChat_Unloading then break end title.TextColor3 = Color3.fromHSV((os.clock() * 0.25) % 1, 0.85, 1); task.wait() end end)
end
if LocalPlayer.Character then AttachUniversalOverhead(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(AttachUniversalOverhead)

if not getgenv().Axer_Honeypots_Active then
	local fakeMetatable = { __index = function() return "AXER_TITANGUARD_SECURE_NODE" end, __newindex = function() if checkcaller and checkcaller() and not getgenv().AxerChat_Unloading then TitanGuardKick("TRP-W02", "Honeypot Write") end end }
	local FakeDB = setmetatable({}, fakeMetatable)
	pcall(function() _G.FIREBASE_ROOT = FakeDB; shared.FirebasePipeline = FakeDB end)
	local SecureRegistryProxy = setmetatable({}, { __index = function() return "DENIED" end, __newindex = function() if not getgenv().AxerChat_Unloading then TitanGuardKick("TRP-M01", "Memory Injection") end end, __metatable = "LOCKED" })
	pcall(function() shared.AxerTitanVault = SecureRegistryProxy end)
	getgenv().Axer_Honeypots_Active = true
end

local function VerifyMetatableIntegrity()
	if getgenv().AxerChat_Unloading then return end
	local getrm = getrawmetatable or function() return nil end
	local isro = isreadonly or function() return true end
	for _, service in ipairs({HttpService, Players, ReplicatedStorage}) do
		local mt = getrm(service); if mt and (typeof(mt) ~= "table" or not isro(mt)) then TitanGuardKick("META-HOOK", "Service Compromised") end
	end
	if ishooked and ishooked(httprequest) then TitanGuardKick("SPY-01", "HTTP Spy") end
end

local function GetUniverseTimestamp() local s, t = pcall(function() return workspace:GetServerTimeNow() end); return s and math.floor(t) or os.time() end
local SESSION_START_TIME = GetUniverseTimestamp(); local SERVER_RETENTION_SECONDS = 86400; local ONE_WEEK_SECONDS = 604800 

local STICKER_LIST = {"77649364", "4575171289", "2939688117", "377662481", "8602843662", "84406977929953", "99638752080138", "11648237431", "5883531940", "9597834616", "12573542769", "13297237968", "135055229700449", "14164452624", "118477781128724", "83990024276263", "15404150022", "168290988", "15149485377", "14742201370", "13329191544", "12753246648", "15314865297", "13276722238", "13249175283", "7037371946", "13967189767", "443560505", "13116796587", "14493140295", "2888515085", "13231918877", "9086717675", "14833591986", "16360873499"}

local function hexToStr(hex) return (hex:gsub('..', function(cc) return string.char(tonumber(cc, 16) or 0) end)) end
math.randomseed(os.time() + tick())
local bxor = bit32 and bit32.bxor or function(a,b) local p,c=1,0 while a>0 or b>0 do if (a%2) ~= (b%2) then c=c+p end a,b,p=math.floor(a/2),math.floor(b/2),p*2 end return c end

local function SignData(data)
	local str = string.upper(tostring(data)) .. "||" .. hexToStr(getSalt()); local hash = 2166136261
	for i = 1, #str do hash = bxor(hash, string.byte(str, i)); hash = (hash * 16777619) % 4294967296 end
	return string.format("%08X", hash)
end

local function RC4(key, data)
	local S = {}; for i = 0, 255 do S[i] = i end; local j = 0
	for i = 0, 255 do j = (j + S[i] + string.byte(key, (i % #key) + 1)) % 256; S[i], S[j] = S[j], S[i] end
	local i, res = 0, {}; j = 0
	for k = 1, #data do i = (i + 1) % 256; j = (j + S[i]) % 256; S[i], S[j] = S[j], S[i]; table.insert(res, string.char(bxor(string.byte(data, k), S[(S[i] + S[j]) % 256]))) end
	return table.concat(res)
end
local function strToHex(str) return string.upper(str:gsub('.', function(c) return string.format('%02X', string.byte(c)) end)) end
local function GenNonce() local c = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"; local n = "" for _ = 1, 8 do local r = math.random(1, #c); n = n .. c:sub(r, r) end return n end
local function SecureEncrypt(key, text) local roomKey = key .. "_TITAN_SECURE_VAULT_V14"; local p = GenNonce() .. text; local h = strToHex(RC4(roomKey, p)); return h, SignData(h) end
local function SecureDecrypt(key, hexText, sig)
	if not hexText or not sig or SignData(hexText) ~= string.upper(tostring(sig)) then return nil end
	local s, r = pcall(hexToStr, hexText); if not s or not r then return nil end
	local d = RC4(key .. "_TITAN_SECURE_VAULT_V14", r); return (#d > 8) and d:sub(9) or nil
end
local function getDMKey(uA, uB) local s = {string.lower(uA), string.lower(uB)}; table.sort(s); return "DM_CIPHER_" .. s[1] .. "_X_" .. s[2] end

local AxerChat = {
	Mode = "Server", ActiveDM = nil, MessagesCount = 0, MaxMessages = 100,
	CurrentTheme = "Dark", ReplyingTo = nil, EditingMsgID = nil, ActiveSwipeBubble = nil,
	SeenIDs = {}, Cache = { Server = {}, DMs = {} }, ActiveBubbleNodes = {},
	AccountRegistry = {}, MuteServerToasts = false, UI = {}, LastSendTime = 0,
	PendingCommitGrace = {}, VIPList = {},
	TitleRegistry = { ["venus_edit"] = "CREATOR" },
	ThrottlingFlags = { BurstCount = 0, LastWindow = os.clock() },
	IsLocked = false, ShadowMuted = {}, MutedKeywords = {},
	LastSentMessage = "", MessageTimestamps = {},
	AdminJoinAlreadyDone = false,  -- set after checking file flag
}

-- Check if admin join already done for this server
local adminJoinFlagFile = "AxerAdminJoin_" .. game.JobId .. ".txt"
if isfile and isfile(adminJoinFlagFile) then
    AxerChat.AdminJoinAlreadyDone = true
end

local function ExecuteWebPush(url, payload)
	local nowWindow = os.clock()
	if nowWindow - AxerChat.ThrottlingFlags.LastWindow < 1.0 then
		AxerChat.ThrottlingFlags.BurstCount = AxerChat.ThrottlingFlags.BurstCount + 1
		if AxerChat.ThrottlingFlags.BurstCount > 10 then return end
	else AxerChat.ThrottlingFlags.BurstCount = 1; AxerChat.ThrottlingFlags.LastWindow = nowWindow end
	task.spawn(function()
		local s, _ = pcall(function() return httprequest({ Url = url, Method = "PUT", Headers = { ["Content-Type"] = "application/json" }, Body = payload }) end)
		if not s then task.wait(1.0); pcall(function() httprequest({ Url = url, Method = "PUT", Headers = { ["Content-Type"] = "application/json" }, Body = payload }) end) end
	end)
end

local function SafeGet(endpoint)
	local buster = tostring(os.clock()):gsub("%.","") .. "_" .. math.random(1000,9999)
	local succ, res = pcall(function() return httprequest({ Url = STATIC_PROXY .. endpoint .. ".json?bust=" .. buster, Method = "GET", Headers = { ["Cache-Control"] = "no-cache", ["Pragma"] = "no-cache" } }) end)
	if succ and typeof(res) == "table" and (res.StatusCode == 200 or res.StatusCode == 304) and res.Body and res.Body ~= "null" then
		local s, dec = pcall(HttpService.JSONDecode, HttpService, res.Body); return (s and typeof(dec) == "table") and dec or nil
	end return nil
end

local Themes = {
	Dark = { MainBg=Color3.fromRGB(8,8,8), HeaderBg=Color3.fromRGB(16,16,16), InputBg=Color3.fromRGB(22,22,22), TextColor=Color3.fromRGB(255,255,255), NameColor=Color3.fromRGB(160,160,160), SubText=Color3.fromRGB(110,110,110), MyBubble=Color3.fromRGB(0,122,255), OtherBubble=Color3.fromRGB(30,30,30), Accent=Color3.fromRGB(0,122,255), BgTrans=0, HeadTrans=0, InpTrans=0, BubOtherTrans=0, BubMeTrans=0, StrokeColor=Color3.fromRGB(45,45,45) },
	Light = { MainBg=Color3.fromRGB(245,245,245), HeaderBg=Color3.fromRGB(255,255,255), InputBg=Color3.fromRGB(255,255,255), TextColor=Color3.fromRGB(15,15,15), NameColor=Color3.fromRGB(100,100,100), SubText=Color3.fromRGB(130,130,130), MyBubble=Color3.fromRGB(0,122,255), OtherBubble=Color3.fromRGB(220,220,225), Accent=Color3.fromRGB(0,122,255), BgTrans=0, HeadTrans=0, InpTrans=0, BubOtherTrans=0, BubMeTrans=0, StrokeColor=Color3.fromRGB(210,210,210) },
	Glass = { MainBg=Color3.fromRGB(10,25,45), HeaderBg=Color3.fromRGB(16,38,65), InputBg=Color3.fromRGB(16,38,65), TextColor=Color3.fromRGB(255,255,255), NameColor=Color3.fromRGB(130,210,255), SubText=Color3.fromRGB(180,200,220), MyBubble=Color3.fromRGB(0,135,255), OtherBubble=Color3.fromRGB(255,255,255), Accent=Color3.fromRGB(0,195,255), BgTrans=0.6, HeadTrans=0.65, InpTrans=0.65, BubOtherTrans=0.85, BubMeTrans=0.35, StrokeColor=Color3.fromRGB(60,140,255) }
}
local ThemeSequence = {"Dark", "Light", "Glass"}; local ThemeIcons = {Dark="🌙", Light="☀️", Glass="🧊"}; local currentThemeIndex = 1

-- VIP bubble styling – now theme‑aware
local function ApplyVIPStyleToBubble(bub, themeKey)
	local t = Themes[themeKey]
	local isMe = (bub.AnchorPoint.X == 1)
	local bgCol = isMe and t.MyBubble or t.OtherBubble
	local bgTrans = isMe and t.BubMeTrans or t.BubOtherTrans

	bub.BackgroundColor3 = bgCol
	bub.BackgroundTransparency = bgTrans
	local grad = bub:FindFirstChild("VIP_Grad")
	if grad then grad:Destroy() end
	local stroke = bub:FindFirstChild("VIP_Stroke")
	if stroke then stroke:Destroy() end
	local nLbl = bub:FindFirstChild("SenderName")
	if nLbl and nLbl.Text ~= "ARIA" then nLbl.TextColor3 = t.NameColor end
	local mLbl = bub:FindFirstChild("MainMessageText")
	if mLbl then mLbl.TextColor3 = t.TextColor end
end

local targetParent = CoreGui or LocalPlayer:WaitForChild("PlayerGui")
local Screen = Instance.new("ScreenGui", targetParent)
Screen.Name = GenerateRandomUIName(); Screen.ResetOnSpawn = false
Screen.IgnoreGuiInset = true; Screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Screen.AncestryChanged:Connect(function(_, newParent)
	if newParent == nil and Screen.Name:find("AxerUI_") and not getgenv().AxerChat_Unloading then
		TitanGuardKick("UI-HIJACK", "UI Container Destroyed")
	end
end)
Screen.Destroying:Connect(function() if Lighting:FindFirstChild("AxerCinematicBlur") then Lighting.AxerCinematicBlur:Destroy() end end)

local ToastFrame = Instance.new("Frame", Screen); ToastFrame.Name = "AxerSmartToastContainer"; ToastFrame.Size = UDim2.new(0, 260, 0.65, 0); ToastFrame.AnchorPoint = Vector2.new(1, 1); ToastFrame.Position = UDim2.new(1, -15, 1, -15); ToastFrame.BackgroundTransparency = 1
local ToastLayout = Instance.new("UIListLayout", ToastFrame); ToastLayout.Padding = UDim.new(0, 10); ToastLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom; ToastLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right; ToastLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function GetHumanReadablePreview(raw)
	if not raw then return "" end
	local _, _, clean = raw:match("^%[RPL::(.-)::(.-)::RPL%]%s*(.*)"); local target = clean or raw
	if target:sub(1,5) == "[EDT]" then target = target:sub(6) end
	if target:match("^%[MEDIA::") then return "🖼️ [Image Vault]" end
	if target:match("^%[STICKER://") then return "🏵️ [Sticker]" end
	return target:gsub("<[^>]+>", "")
end

function AxerChat.SyncNativeRobloxBubbleSettings()
	local isGlass = (AxerChat.CurrentTheme == "Glass"); local isLight = (AxerChat.CurrentTheme == "Light")
	local bgCol = isLight and Color3.fromRGB(255, 255, 255) or (isGlass and Color3.fromRGB(10, 25, 45) or Color3.fromRGB(15, 15, 15))
	local txtCol = isLight and Color3.fromRGB(15, 15, 15) or Color3.fromRGB(255, 255, 255)
	pcall(function() local tcs = game:GetService("TextChatService"); if tcs and tcs:FindFirstChild("BubbleChatConfiguration") then tcs.BubbleChatConfiguration.BackgroundColor3 = bgCol; tcs.BubbleChatConfiguration.TextColor3 = txtCol end end)
	pcall(function() game:GetService("Chat"):SetBubbleChatSettings({BackgroundColor3 = bgCol, TextColor3 = txtCol}) end)
end

local VAULT_FILE = "AxerImageVault_" .. LocalPlayer.UserId .. ".json"
local function GetDiskVault() if not readfile then return {} end local s, r = pcall(function() return HttpService:JSONDecode(readfile(VAULT_FILE)) end); return (s and typeof(r)=="table") and r or {} end
local function SaveDiskVault(t) if writefile then pcall(function() writefile(VAULT_FILE, HttpService:JSONEncode(t)) end) end end

local READ_FILE = "AxerReadState_" .. LocalPlayer.UserId .. ".json"
function AxerChat.GetLastRead(partnerLower) if not readfile then return 0 end local s, r = pcall(function() return HttpService:JSONDecode(readfile(READ_FILE)) end); return (s and typeof(r)=="table" and r[partnerLower]) and tonumber(r[partnerLower]) or 0 end
function AxerChat.SetLastRead(partnerLower, timestamp) if not writefile then return end local s, r = pcall(function() return HttpService:JSONDecode(readfile(READ_FILE)) end); local st = (s and typeof(r)=="table") and r or {}; st[partnerLower] = timestamp; pcall(function() writefile(READ_FILE, HttpService:JSONEncode(st)) end) end
function AxerChat.GetUnreadCount(partnerLower) local cnt = 0; local lr = AxerChat.GetLastRead(partnerLower); for _, m in ipairs(AxerChat.Cache.DMs[partnerLower] or {}) do if m.Time > lr and m.UserID ~= LocalPlayer.UserId then cnt = cnt + 1 end end return cnt end

function AxerChat.RegisterAccount(rawUsername, rawDisplayName, rawUserId)
	if not rawUsername or typeof(rawUsername) ~= "string" or rawUsername == "" then return end
	AxerChat.AccountRegistry[rawUsername:lower()] = { Username = rawUsername, DisplayName = rawDisplayName or rawUsername, UserId = rawUserId or 1 }
end
function AxerChat.GetAccount(usernameLower)
	if not usernameLower or typeof(usernameLower) ~= "string" then return { Username = "Unknown", DisplayName = "Unknown", UserId = 1 } end
	local tk = usernameLower:lower(); if AxerChat.AccountRegistry[tk] then return AxerChat.AccountRegistry[tk] end
	for _, p in ipairs(Players:GetPlayers()) do if p.Name:lower() == tk then AxerChat.RegisterAccount(p.Name, p.DisplayName, p.UserId); return AxerChat.AccountRegistry[tk] end end
	return { Username = usernameLower, DisplayName = usernameLower, UserId = 1 }
end

local function ApplyWebImage(imgObj, url)
	if not url then return end
	if url:sub(1,10):lower() == "rbxassetid" or url:sub(1,9):lower() == "rbxthumb:" then imgObj.Image = url; return end
	if not getcustomasset or not writefile or not isfile then return end
	local safeHash = SignData(url); local fileName = "AxerMediaCache_" .. safeHash .. ".png"
	if pcall(isfile, fileName) and isfile(fileName) then pcall(function() imgObj.Image = getcustomasset(fileName) end); return end
	task.spawn(function() local succ, res = pcall(function() return httprequest({Url = url, Method = "GET"}) end); if succ and res and res.StatusCode == 200 and res.Body then pcall(function() writefile(fileName, res.Body); imgObj.Image = getcustomasset(fileName) end) end end)
end

-- [ 🖼️ ARIA PROFILE PICTURE ]
local function loadDP(img, user)
	if user == "ARIA" then img.Image = "rbxassetid://92917449577250"; return end
	task.spawn(function() local p = Players:FindFirstChild(user); local succ, fId = pcall(function() return Players:GetUserIdFromNameAsync(user) end); local id = p and p.UserId or (succ and fId or 1); img.Image = Players:GetUserThumbnailAsync(id, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48) end)
end

function AxerChat.DispatchGodCommand(cmdStr)
	if not IsStrictAdmin() then TitanGuardKick("GOD-SPOOF", "Illegal God Execution") return end
	
	if cmdStr:sub(1, 9) == "BAN_USER:" then
		local u = cmdStr:sub(10):lower()
		task.spawn(function() httprequest({Url = STATIC_PROXY .. "ZaynMasterFinal/Blacklist/Accounts/" .. u .. ".json", Method = "PUT", Body = "true"}) end)
	elseif cmdStr:sub(1, 11) == "UNBAN_USER:" then
		local u = cmdStr:sub(12):lower()
		task.spawn(function() 
			local mapRes = pcall(function() return httprequest({Url = STATIC_PROXY .. "ZaynMasterFinal/Blacklist/Accounts/" .. u .. ".json?bust="..tostring(os.clock())}).Body end)
			if mapRes and type(mapRes) == "string" and mapRes ~= "null" and mapRes ~= "true" then
				local hwid = mapRes:gsub('"', '')
				httprequest({Url = STATIC_PROXY .. "ZaynMasterFinal/Blacklist/HWIDs/" .. hwid .. ".json", Method = "DELETE"})
			end
			httprequest({Url = STATIC_PROXY .. "ZaynMasterFinal/Blacklist/Accounts/" .. u .. ".json", Method = "DELETE"}) 
		end)
	elseif cmdStr:sub(1, 10) == "LOCK_CHAT:" then
		task.spawn(function() httprequest({Url = STATIC_PROXY .. "ZaynSystemLocks_v3/" .. cmdStr:sub(11):lower() .. ".json", Method = "PUT", Body = "true"}) end)
	elseif cmdStr:sub(1, 12) == "UNLOCK_CHAT:" then
		task.spawn(function() httprequest({Url = STATIC_PROXY .. "ZaynSystemLocks_v3/" .. cmdStr:sub(13):lower() .. ".json", Method = "DELETE"}) end)
	elseif cmdStr:sub(1, 13) == "MUTE_KEYWORD:" then
		task.spawn(function() httprequest({Url = STATIC_PROXY .. "ZaynSystemMutes_v3/Keywords/" .. cmdStr:sub(14):lower() .. ".json", Method = "PUT", Body = "true"}) end)
	elseif cmdStr:sub(1, 15) == "UNMUTE_KEYWORD:" then
		task.spawn(function() httprequest({Url = STATIC_PROXY .. "ZaynSystemMutes_v3/Keywords/" .. cmdStr:sub(16):lower() .. ".json", Method = "DELETE"}) end)
	end

	local ciph, sgn = SecureEncrypt("AXER_DEV_ABSOLUTE_ADMIN_WALL_777x0", cmdStr)
	httprequest({Url=STATIC_PROXY.."Srv/"..REAL_JOB_ID.."/SYS_NET_GOD_"..os.time().."_"..math.random(100,999).. ".json", Method="PUT", Body=HttpService:JSONEncode({ u=LocalPlayer.UserId, s="SYS_ARIA_ADMIN", m=ciph, sign=sgn, t=GetUniverseTimestamp() })})
	AxerChat.TriggerToast("⚙️ Admin Action", "Command Issued: " .. cmdStr:match("^(.-):"), false)
end

function AxerChat.SetLockState(isLocked)
	AxerChat.IsLocked = isLocked
	if not AxerChat.UI.TextBox then return end
	if isLocked then
		AxerChat.UI.TextBox.TextEditable = false
		AxerChat.UI.TextBox.ClearTextOnFocus = false
		AxerChat.UI.TextBox.Text = ""
		AxerChat.UI.TextBox.PlaceholderText = "🔒 CHAT LOCKED BY ADMIN"
		AxerChat.UI.TextBox.TextColor3 = Color3.fromRGB(255, 80, 80)
		AxerChat.UI.SendBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
	else
		AxerChat.UI.TextBox.TextEditable = true
		AxerChat.UI.TextBox.PlaceholderText = "Type message..."
		AxerChat.UI.TextBox.TextColor3 = Themes[AxerChat.CurrentTheme].TextColor
		AxerChat.UI.SendBtn.BackgroundColor3 = Themes[AxerChat.CurrentTheme].Accent
	end
end

-- [ 🤖 ARIA WARNING ENGINE ]
function AxerChat.TriggerAriaLocal(msgText)
	local zID = "SYS_LOCAL_WARN_" .. tostring(os.clock()) .. "_" .. math.random(1000,9999)
	local targetCache = (AxerChat.Mode == "DM" and AxerChat.ActiveDM) and AxerChat.Cache.DMs[AxerChat.ActiveDM] or AxerChat.Cache.Server
	table.insert(targetCache, {Sender="ARIA", UserID=0, Msg=msgText, Time=os.time(), ID=zID, Edited=false})
	AxerChat.RenderBubble("ARIA", 0, msgText, os.time(), zID, false)
	AxerChat.HandleScroll(true)
end

task.spawn(function()
	local s, b = pcall(function() return httprequest({Url = STATIC_PROXY .. "ZaynSystemLocks_v3/" .. LocalPlayer.Name:lower() .. ".json?bust="..tostring(os.clock())}).Body end)
	if s and b == "true" then AxerChat.SetLockState(true) end
	local s2, r2 = pcall(function() return httprequest({Url = STATIC_PROXY .. "ZaynSystemMutes_v3/Keywords.json?bust="..tostring(os.clock())}).Body end)
	if s2 and r2 and r2 ~= "null" then local kw = HttpService:JSONDecode(r2); if type(kw) == "table" then AxerChat.MutedKeywords = kw end end
end)

function AxerChat.BuildMasterUI()
	local t = Themes.Dark
	local ToggleBtn = Instance.new("ImageButton", Screen); ToggleBtn.Name = "AxerMovableToggle"; ToggleBtn.Size = UDim2.new(0,42,0,42); ToggleBtn.Position = UDim2.new(0,15,0.5,-21); 
	-- [ 🖼️ MINIMIZER LOGO - UPDATED ]
	ToggleBtn.Image = "rbxassetid://106542899596174";
	ToggleBtn.BackgroundColor3 = Color3.fromRGB(15,15,15); Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1,0); Instance.new("UIStroke", ToggleBtn).Color = Color3.fromRGB(255,255,255)
	local MainFrame = Instance.new("Frame", Screen); MainFrame.Name = "AxerMainFrame"; MainFrame.Size = UDim2.new(0,440,0,350); MainFrame.Position = UDim2.new(0.5,-220,0.5,-175); MainFrame.BackgroundColor3 = t.MainBg; MainFrame.Visible = false; MainFrame.Active = true; MainFrame.Draggable = true; Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,16); local MainStroke = Instance.new("UIStroke", MainFrame); MainStroke.Color = t.StrokeColor

	local dragTog, startP, togStart, hasDragged = false, nil, nil, false
	ToggleBtn.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragTog=true; startP=inp.Position; togStart=ToggleBtn.Position; hasDragged=false end end)
	UserInputService.InputChanged:Connect(function(inp) if dragTog and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local delta=inp.Position-startP; if delta.Magnitude>5 then hasDragged=true; ToggleBtn.Position=UDim2.new(togStart.X.Scale, togStart.X.Offset+delta.X, togStart.Y.Scale, togStart.Y.Offset+delta.Y) end end end)
	ToggleBtn.InputEnded:Connect(function(inp) if dragTog and (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then dragTog=false; if not hasDragged then MainFrame.Visible = not MainFrame.Visible; if MainFrame.Visible then AxerChat.SwitchMode(AxerChat.Mode, AxerChat.ActiveDM); AxerChat.HandleScroll(true) end end end end)

	local Header = Instance.new("Frame", MainFrame); Header.Size = UDim2.new(1,0,0,34); Header.BackgroundColor3 = t.HeaderBg; Header.BorderSizePixel = 0; Instance.new("UICorner", Header).CornerRadius = UDim.new(0,14)
	local BackBtn = Instance.new("TextButton", Header); BackBtn.Size = UDim2.new(0,30,1,0); BackBtn.Position = UDim2.new(0,5,0,0); BackBtn.BackgroundTransparency = 1; BackBtn.Font = Enum.Font.GothamBold; BackBtn.Text = "◀"; BackBtn.TextSize = 15; BackBtn.TextColor3 = t.MyBubble; BackBtn.Visible = false
	local HeaderDP = Instance.new("ImageLabel", Header); HeaderDP.Name = "ActiveDMProfilePic"; HeaderDP.Size = UDim2.new(0, 24, 0, 24); HeaderDP.Position = UDim2.new(0, 38, 0.5, -12); HeaderDP.BackgroundTransparency = 1; HeaderDP.Visible = false; Instance.new("UICorner", HeaderDP).CornerRadius = UDim.new(1, 0)
	local Title = Instance.new("TextLabel", Header); Title.Name = "MainTitle"; Title.Size = UDim2.new(0,210,1,0); Title.Position = UDim2.new(0,15,0,0); Title.BackgroundTransparency = 1; Title.Text = "AXER CHAT"; Title.Font = Enum.Font.GothamBold; Title.TextSize = 14; Title.TextColor3 = t.TextColor; Title.TextXAlignment = Enum.TextXAlignment.Left; Title.RichText = true

	local ThemeBtn = Instance.new("TextButton", Header); ThemeBtn.Size = UDim2.new(0,26,0,26); ThemeBtn.Position = UDim2.new(1,-32,0.5,-13); ThemeBtn.BackgroundColor3 = t.InputBg; ThemeBtn.Text = ThemeIcons[ThemeSequence[currentThemeIndex]]; ThemeBtn.Font = Enum.Font.GothamBold; ThemeBtn.TextSize = 13; Instance.new("UICorner", ThemeBtn).CornerRadius = UDim.new(0,8)
	local InboxBtn = Instance.new("TextButton", Header); InboxBtn.Size = UDim2.new(0,26,0,26); InboxBtn.Position = UDim2.new(1,-64,0.5,-13); InboxBtn.BackgroundColor3 = t.InputBg; InboxBtn.Text = "📩"; InboxBtn.Font = Enum.Font.GothamBold; InboxBtn.TextSize = 13; Instance.new("UICorner", InboxBtn).CornerRadius = UDim.new(0,8)
	local MuteBtn = Instance.new("TextButton", Header); MuteBtn.Size = UDim2.new(0,26,0,26); MuteBtn.Position = UDim2.new(1,-96,0.5,-13); MuteBtn.BackgroundColor3 = t.InputBg; MuteBtn.Text = "🔊"; MuteBtn.Font = Enum.Font.GothamBold; MuteBtn.TextSize = 13; Instance.new("UICorner", MuteBtn).CornerRadius = UDim.new(0,8)

	local SearchWrapper = Instance.new("Frame", MainFrame); SearchWrapper.Name = "AxerGlobalSearch"; SearchWrapper.Size = UDim2.new(1,-20,0,36); SearchWrapper.Position = UDim2.new(0,10,0,40); SearchWrapper.BackgroundColor3 = t.InputBg; SearchWrapper.Visible = false; Instance.new("UICorner", SearchWrapper).CornerRadius = UDim.new(0,18)
	local SearchInput = Instance.new("TextBox", SearchWrapper); SearchInput.Size = UDim2.new(1,-20,1,0); SearchInput.Position = UDim2.new(0,15,0,0); SearchInput.BackgroundTransparency = 1; SearchInput.Font = Enum.Font.GothamMedium; SearchInput.TextSize = 12; SearchInput.TextColor3 = t.TextColor; SearchInput.PlaceholderText = "Type exact username or partial name..."; SearchInput.PlaceholderColor3 = t.SubText; SearchInput.TextXAlignment = Enum.TextXAlignment.Left; SearchInput.ClearTextOnFocus = false; SearchInput.Text = ""

	local Scroll = Instance.new("ScrollingFrame", MainFrame); Scroll.Size = UDim2.new(1,0,1,-80); Scroll.Position = UDim2.new(0,0,0,34); Scroll.BackgroundTransparency = 1; Scroll.ScrollBarThickness = 2; Scroll.AutomaticCanvasSize = Enum.AutomaticSize.None
	local ScrollLayout = Instance.new("UIListLayout", Scroll); ScrollLayout.Padding = UDim.new(0,8)
	local SPad = Instance.new("UIPadding", Scroll); SPad.PaddingLeft = UDim.new(0,15); SPad.PaddingRight = UDim.new(0,15); SPad.PaddingTop = UDim.new(0,10); SPad.PaddingBottom = UDim.new(0,10)
	ScrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() local pTotal=SPad.PaddingTop.Offset+SPad.PaddingBottom.Offset; Scroll.CanvasSize=UDim2.new(0,0,0,ScrollLayout.AbsoluteContentSize.Y+pTotal+25) end)

	local JumpBtn = Instance.new("TextButton", MainFrame); JumpBtn.Name = "AxerJumpBtn"; JumpBtn.Size = UDim2.new(0,34,0,34); JumpBtn.Position = UDim2.new(1,-45,1,-90); JumpBtn.BackgroundColor3 = t.Accent; JumpBtn.Text = "⬇️"; JumpBtn.Font = Enum.Font.GothamBold; JumpBtn.TextSize = 14; JumpBtn.TextColor3 = Color3.fromRGB(255,255,255); Instance.new("UICorner", JumpBtn).CornerRadius = UDim.new(1,0); JumpBtn.Visible = false
	JumpBtn.MouseButton1Click:Connect(function() AxerChat.HandleScroll(true) end)

	local ReplyPreview = Instance.new("Frame", MainFrame); ReplyPreview.Name = "AxerReplyPocketBar"; ReplyPreview.Size = UDim2.new(1,-20,0,36); ReplyPreview.Position = UDim2.new(0,10,1,-46); ReplyPreview.BackgroundColor3 = t.InputBg; ReplyPreview.Visible = false; ReplyPreview.ZIndex = 2; Instance.new("UICorner", ReplyPreview).CornerRadius = UDim.new(0,8)
	local ReplyIcon = Instance.new("TextLabel", ReplyPreview); ReplyIcon.Name = "RepIcon"; ReplyIcon.Size = UDim2.new(0,25,1,0); ReplyIcon.Position = UDim2.new(0,5,0,0); ReplyIcon.BackgroundTransparency = 1; ReplyIcon.Text = "↩"; ReplyIcon.Font = Enum.Font.GothamBold; ReplyIcon.TextSize = 15; ReplyIcon.TextColor3 = t.MyBubble; ReplyIcon.ZIndex = 2
	local ReplyText = Instance.new("TextLabel", ReplyPreview); ReplyText.Name = "RepText"; ReplyText.Size = UDim2.new(1,-60,1,0); ReplyText.Position = UDim2.new(0,30,0,0); ReplyText.BackgroundTransparency = 1; ReplyText.Font = Enum.Font.GothamMedium; ReplyText.TextSize = 11; ReplyText.TextColor3 = t.SubText; ReplyText.TextXAlignment = Enum.TextXAlignment.Left; ReplyText.RichText = true; ReplyText.ZIndex = 2
	local CancelRep = Instance.new("TextButton", ReplyPreview); CancelRep.Size = UDim2.new(0,22,0,22); CancelRep.Position = UDim2.new(1,-28,0.5,-11); CancelRep.BackgroundColor3 = t.MainBg; CancelRep.Text = "X"; CancelRep.TextColor3 = t.SubText; CancelRep.Font = Enum.Font.GothamBold; CancelRep.ZIndex = 2; Instance.new("UICorner", CancelRep).CornerRadius = UDim.new(1,0)

	local InputWrapper = Instance.new("Frame", MainFrame); InputWrapper.Size = UDim2.new(1,-20,0,38); InputWrapper.Position = UDim2.new(0,10,1,-46); InputWrapper.BackgroundColor3 = t.InputBg; InputWrapper.ZIndex = 3; Instance.new("UICorner", InputWrapper).CornerRadius = UDim.new(0,19)
	local TextBox = Instance.new("TextBox", InputWrapper); TextBox.Size = UDim2.new(1,-120,1,0); TextBox.Position = UDim2.new(0,15,0,0); TextBox.BackgroundTransparency = 1; TextBox.Font = Enum.Font.GothamMedium; TextBox.TextSize = 12; TextBox.TextColor3 = t.TextColor; TextBox.PlaceholderText = "Type message..."; TextBox.PlaceholderColor3 = t.SubText; TextBox.TextXAlignment = Enum.TextXAlignment.Left; TextBox.ClearTextOnFocus = false; TextBox.Text = ""; TextBox.ZIndex = 3
	
	local SendBtn = Instance.new("TextButton", InputWrapper); SendBtn.Size = UDim2.new(0,34,0,28); SendBtn.Position = UDim2.new(1,-38,0.5,-14); SendBtn.BackgroundColor3 = t.Accent; SendBtn.Text = "▶︎"; SendBtn.Font = Enum.Font.GothamBold; SendBtn.TextSize = 14; SendBtn.TextColor3 = Color3.fromRGB(255,255,255); SendBtn.ZIndex = 3; Instance.new("UICorner", SendBtn).CornerRadius = UDim.new(0,8)
	local StickerBtn = Instance.new("TextButton", InputWrapper); StickerBtn.Size = UDim2.new(0,32,0,28); StickerBtn.Position = UDim2.new(1,-74,0.5,-14); StickerBtn.BackgroundColor3 = t.HeaderBg; StickerBtn.Text = "🏵️"; StickerBtn.Font = Enum.Font.GothamBold; StickerBtn.TextSize = 13; StickerBtn.ZIndex = 3; Instance.new("UICorner", StickerBtn).CornerRadius = UDim.new(0,8)
	local ImageBtn = Instance.new("TextButton", InputWrapper); ImageBtn.Size = UDim2.new(0,32,0,28); ImageBtn.Position = UDim2.new(1,-110,0.5,-14); ImageBtn.BackgroundColor3 = t.HeaderBg; ImageBtn.Text = "🖼️"; ImageBtn.Font = Enum.Font.GothamBold; ImageBtn.TextSize = 13; ImageBtn.ZIndex = 3; Instance.new("UICorner", ImageBtn).CornerRadius = UDim.new(0,8)

	local StickerTray = Instance.new("Frame", MainFrame); StickerTray.Size = UDim2.new(1,-20,0,165); StickerTray.Position = UDim2.new(0,10,1,-216); StickerTray.BackgroundColor3 = Color3.fromRGB(16,16,16); StickerTray.Visible = false; StickerTray.ZIndex = 50; Instance.new("UICorner", StickerTray).CornerRadius = UDim.new(0,14); Instance.new("UIStroke", StickerTray).Color = t.Accent
	local StkScroll = Instance.new("ScrollingFrame", StickerTray); StkScroll.Size = UDim2.new(1,0,1,0); StkScroll.BackgroundTransparency = 1; StkScroll.ScrollBarThickness = 2; StkScroll.ZIndex = 51; StkScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; local Grid = Instance.new("UIGridLayout", StkScroll); Grid.CellSize = UDim2.new(0,52,0,52); Grid.CellPadding = UDim2.new(0,8,0,8); Grid.HorizontalAlignment = Enum.HorizontalAlignment.Center; Grid.SortOrder = Enum.SortOrder.LayoutOrder; Instance.new("UIPadding", StkScroll).PaddingTop = UDim.new(0,10); StkScroll.UIPadding.PaddingBottom = UDim.new(0,10)
	for _, stkid in ipairs(STICKER_LIST) do local box = Instance.new("ImageButton", StkScroll); box.BackgroundColor3 = t.InputBg; box.BackgroundTransparency = 1; box.ZIndex = 52; box.Image = "rbxthumb://type=Asset&id="..stkid.."&w=150&h=150"; box.ScaleType = Enum.ScaleType.Fit; box.MouseButton1Click:Connect(function() AxerChat.Send("[STICKER://"..stkid.."]"); StickerTray.Visible = false end) end

	local ImageTray = Instance.new("Frame", MainFrame); ImageTray.Name = "AxerImageVaultTray"; ImageTray.Size = UDim2.new(1,-20,0,215); ImageTray.Position = UDim2.new(0,10,1,-265); ImageTray.BackgroundColor3 = Color3.fromRGB(16,16,16); ImageTray.Visible = false; ImageTray.ZIndex = 70; Instance.new("UICorner", ImageTray).CornerRadius = UDim.new(0,14); Instance.new("UIStroke", ImageTray).Color = t.Accent
	local AriaBanner = Instance.new("Frame", ImageTray); AriaBanner.Name = "AriaBanner"; AriaBanner.Size = UDim2.new(1,-16,0,36); AriaBanner.Position = UDim2.new(0,8,0,8); AriaBanner.BackgroundColor3 = Color3.fromRGB(26,15,38); AriaBanner.ZIndex = 71; Instance.new("UICorner", AriaBanner).CornerRadius = UDim.new(0,8); Instance.new("UIStroke", AriaBanner).Color = Color3.fromRGB(180,60,255)
	local AriaDP = Instance.new("ImageLabel", AriaBanner); AriaDP.Size = UDim2.new(0,26,0,26); AriaDP.Position = UDim2.new(0,6,0.5,-13); AriaDP.BackgroundTransparency = 1; AriaDP.Image = "rbxassetid://92917449577250"; AriaDP.ZIndex = 72; Instance.new("UICorner", AriaDP).CornerRadius = UDim.new(1,0)
	local AriaMsg = Instance.new("TextLabel", AriaBanner); AriaMsg.Size = UDim2.new(1,-44,1,0); AriaMsg.Position = UDim2.new(0,38,0,0); AriaMsg.BackgroundTransparency = 1; AriaMsg.Font = Enum.Font.GothamMedium; AriaMsg.TextSize = 11; AriaMsg.TextColor3 = Color3.fromRGB(255,255,255); AriaMsg.RichText = true; AriaMsg.TextXAlignment = Enum.TextXAlignment.Left; AriaMsg.ZIndex = 72; AriaMsg.Text = "<font color='#B43CFF'><b>ARIA :</b></font> Confused..? Type <b>/helpphoto</b> in Chat!"

	local VaultTopBar = Instance.new("Frame", ImageTray); VaultTopBar.Name = "TopBar"; VaultTopBar.Size = UDim2.new(1,-16,0,32); VaultTopBar.Position = UDim2.new(0,8,0,50); VaultTopBar.BackgroundTransparency = 1; VaultTopBar.ZIndex = 71
	local UrlBox = Instance.new("TextBox", VaultTopBar); UrlBox.Name = "UrlBox"; UrlBox.Size = UDim2.new(1,-70,1,0); UrlBox.BackgroundColor3 = t.InputBg; UrlBox.TextColor3 = t.TextColor; UrlBox.Font = Enum.Font.GothamMedium; UrlBox.TextSize = 11; UrlBox.PlaceholderText = "Url Photo (link dalo)..."; UrlBox.PlaceholderColor3 = t.SubText; UrlBox.TextXAlignment = Enum.TextXAlignment.Left; UrlBox.ClearTextOnFocus = false; UrlBox.ZIndex = 72; Instance.new("UICorner", UrlBox).CornerRadius = UDim.new(0,6); Instance.new("UIPadding", UrlBox).PaddingLeft = UDim.new(0,8)
	local SaveImgBtn = Instance.new("TextButton", VaultTopBar); SaveImgBtn.Name = "SaveBtn"; SaveImgBtn.Size = UDim2.new(0,62,1,0); SaveImgBtn.Position = UDim2.new(1,-62,0,0); SaveImgBtn.BackgroundColor3 = t.Accent; SaveImgBtn.Font = Enum.Font.GothamBold; SaveImgBtn.TextSize = 11; SaveImgBtn.TextColor3 = Color3.fromRGB(255,255,255); SaveImgBtn.Text = "📥 Save"; SaveImgBtn.ZIndex = 72; Instance.new("UICorner", SaveImgBtn).CornerRadius = UDim.new(0,6)

	local VaultScroll = Instance.new("ScrollingFrame", ImageTray); VaultScroll.Name = "VaultScroll"; VaultScroll.Size = UDim2.new(1,-16,1,-92); VaultScroll.Position = UDim2.new(0,8,0,88); VaultScroll.BackgroundTransparency = 1; VaultScroll.ScrollBarThickness = 2; VaultScroll.AutomaticCanvasSize = Enum.AutomaticSize.None; VaultScroll.ZIndex = 71
	local VGrid = Instance.new("UIGridLayout", VaultScroll); VGrid.CellSize = UDim2.new(0,58,0,58); VGrid.CellPadding = UDim2.new(0,8,0,8); VGrid.HorizontalAlignment = Enum.HorizontalAlignment.Left

	-- [ 👑 THE APEX STEALTH ADMIN PANEL ]
	if IsStrictAdmin() then
		local AdminBtn = Instance.new("TextButton", Header); AdminBtn.Name = "AxerSettingsAdmin"; AdminBtn.Size = UDim2.new(0,26,0,26); AdminBtn.Position = UDim2.new(1,-128,0.5,-13); AdminBtn.BackgroundColor3 = t.InputBg; AdminBtn.Text = "⚙️"; AdminBtn.Font = Enum.Font.GothamBold; AdminBtn.TextSize = 13; Instance.new("UICorner", AdminBtn).CornerRadius = UDim.new(0,8)
		local AdminTray = Instance.new("Frame", MainFrame); AdminTray.Name = "AxerAdminControlTray"; AdminTray.Size = UDim2.new(1,-20,0,290); AdminTray.Position = UDim2.new(0,10,1,-340); AdminTray.BackgroundColor3 = t.HeaderBg; AdminTray.Visible = false; AdminTray.ZIndex = 90; Instance.new("UICorner", AdminTray).CornerRadius = UDim.new(0,14); Instance.new("UIStroke", AdminTray).Color = t.Accent
		local SearchBar = Instance.new("TextBox", AdminTray); SearchBar.Size = UDim2.new(1,-50,0,32); SearchBar.Position = UDim2.new(0,8,0,8); SearchBar.BackgroundColor3 = t.InputBg; SearchBar.TextColor3 = t.TextColor; SearchBar.Font = Enum.Font.GothamMedium; SearchBar.TextSize = 11; SearchBar.PlaceholderText = "Search User OR Keyword..."; SearchBar.PlaceholderColor3 = t.SubText; SearchBar.TextXAlignment = Enum.TextXAlignment.Left; SearchBar.ClearTextOnFocus = false; SearchBar.ZIndex = 91; Instance.new("UICorner", SearchBar).CornerRadius = UDim.new(0,6); Instance.new("UIPadding", SearchBar).PaddingLeft = UDim.new(0,8)
		
		local AdminCloseBtn = Instance.new("TextButton", AdminTray); AdminCloseBtn.Size = UDim2.new(0,32,0,32); AdminCloseBtn.Position = UDim2.new(1,-40,0,8); AdminCloseBtn.BackgroundColor3 = Color3.fromRGB(45,35,40); AdminCloseBtn.Text = "❌"; AdminCloseBtn.Font = Enum.Font.GothamBold; AdminCloseBtn.TextSize = 12; AdminCloseBtn.ZIndex = 92; Instance.new("UICorner", AdminCloseBtn).CornerRadius = UDim.new(0,6)
		AdminCloseBtn.MouseButton1Click:Connect(function() AdminTray.Visible = false end)

		local kwBar = Instance.new("Frame", AdminTray); kwBar.Size = UDim2.new(1,-16,0,30); kwBar.Position = UDim2.new(0,8,0,46); kwBar.BackgroundTransparency = 1; kwBar.ZIndex = 91
		local mBtn = Instance.new("TextButton", kwBar); mBtn.Size = UDim2.new(0.48,0,1,0); mBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40); mBtn.Text = "🔇 MUTE KEYWORD"; mBtn.Font = Enum.Font.GothamBold; mBtn.TextSize = 10; mBtn.TextColor3 = Color3.fromRGB(255,255,255); mBtn.ZIndex = 92; Instance.new("UICorner", mBtn).CornerRadius = UDim.new(0,6)
		local umBtn = Instance.new("TextButton", kwBar); umBtn.Size = UDim2.new(0.48,0,1,0); umBtn.Position = UDim2.new(0.52,0,0,0); umBtn.BackgroundColor3 = Color3.fromRGB(40, 150, 80); umBtn.Text = "🔊 UNMUTE KEYWORD"; umBtn.Font = Enum.Font.GothamBold; umBtn.TextSize = 10; umBtn.TextColor3 = Color3.fromRGB(255,255,255); umBtn.ZIndex = 92; Instance.new("UICorner", umBtn).CornerRadius = UDim.new(0,6)
		mBtn.MouseButton1Click:Connect(function() local t = SearchBar.Text:lower():match("^%s*(.-)%s*$"); if t and t~="" then AxerChat.DispatchGodCommand("MUTE_KEYWORD:"..t); SearchBar.Text="" end end)
		umBtn.MouseButton1Click:Connect(function() local t = SearchBar.Text:lower():match("^%s*(.-)%s*$"); if t and t~="" then AxerChat.DispatchGodCommand("UNMUTE_KEYWORD:"..t); SearchBar.Text="" end end)

		local UsrScroll = Instance.new("ScrollingFrame", AdminTray); UsrScroll.Name = "UserList"; UsrScroll.Size = UDim2.new(1,-16,1,-86); UsrScroll.Position = UDim2.new(0,8,0,80); UsrScroll.BackgroundTransparency = 1; UsrScroll.ScrollBarThickness = 2; UsrScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; UsrScroll.ZIndex = 91
		local UsrLayout = Instance.new("UIListLayout", UsrScroll); UsrLayout.Padding = UDim.new(0,6); UsrLayout.SortOrder = Enum.SortOrder.LayoutOrder

		local function OpenAdminActionModal(uName, dName)
			if MainFrame:FindFirstChild("AxerAdminModal") then MainFrame.AxerAdminModal:Destroy() end
			local Overlay = Instance.new("Frame", MainFrame); Overlay.Name = "AxerAdminModal"; Overlay.Size = UDim2.new(1,0,1,0); Overlay.BackgroundColor3 = Color3.fromRGB(0,0,0); Overlay.BackgroundTransparency = 0.5; Overlay.Active = true; Overlay.ZIndex = 95
			local Box = Instance.new("Frame", Overlay); Box.Size = UDim2.new(0,240,0,225); Box.Position = UDim2.new(0.5,0,0.5,0); Box.AnchorPoint = Vector2.new(0.5,0.5); Box.BackgroundColor3 = t.HeaderBg; Box.ZIndex = 96; Instance.new("UICorner", Box).CornerRadius = UDim.new(0,12); Instance.new("UIStroke", Box).Color = t.Accent
			local Lyt = Instance.new("UIListLayout", Box); Lyt.Padding = UDim.new(0,6); Lyt.HorizontalAlignment = Enum.HorizontalAlignment.Center; Instance.new("UIPadding", Box).PaddingTop = UDim.new(0,10)
			
			local Tl = Instance.new("TextLabel", Box); Tl.Size = UDim2.new(1,-20,0,24); Tl.BackgroundTransparency = 1; Tl.Font = Enum.Font.GothamBold; Tl.TextSize = 12; Tl.TextColor3 = t.TextColor; Tl.Text = "Manage: " .. dName; Tl.ZIndex = 97
			
			local function mkBtn(n, col, act)
				local b = Instance.new("TextButton", Box); b.Size = UDim2.new(1,-30,0,30); b.BackgroundColor3 = col; b.Text = n; b.Font = Enum.Font.GothamBold; b.TextSize = 11; b.TextColor3 = Color3.fromRGB(255,255,255); b.ZIndex = 97; Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
				b.MouseButton1Click:Connect(function() act(uName:lower()); Overlay:Destroy() end)
			end
			mkBtn("🔨 HWID BAN", Color3.fromRGB(200,45,45), function(u) AxerChat.DispatchGodCommand("BAN_USER:"..u) end)
			mkBtn("✅ UNBAN", Color3.fromRGB(45,150,200), function(u) AxerChat.DispatchGodCommand("UNBAN_USER:"..u) end)
			mkBtn("🔒 LOCK CHAT", Color3.fromRGB(210,110,20), function(u) AxerChat.DispatchGodCommand("LOCK_CHAT:"..u) end)
			mkBtn("🔓 UNLOCK CHAT", Color3.fromRGB(30,160,80), function(u) AxerChat.DispatchGodCommand("UNLOCK_CHAT:"..u) end)
			mkBtn("👻 SHADOW MUTE", Color3.fromRGB(130,40,190), function(u) AxerChat.DispatchGodCommand("SHADOW_MUTE:"..u) end)
			mkBtn("❌ CANCEL", Color3.fromRGB(80,80,80), function() end)
		end

		local function RenderAdminCards(filter)
			for _, c in pairs(UsrScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
			local seen = {}; local q = filter and filter:lower() or ""
			local function addCard(un, dn, uid)
				if seen[un:lower()] or (q ~= "" and not un:lower():find(q) and not dn:lower():find(q)) then return end
				seen[un:lower()] = true
				local c = Instance.new("TextButton", UsrScroll); c.Size = UDim2.new(1,0,0,42); c.BackgroundColor3 = t.InputBg; c.Text = ""; c.ZIndex = 92; Instance.new("UICorner", c).CornerRadius = UDim.new(0,8)
				local p = Instance.new("ImageLabel", c); p.Size = UDim2.new(0,30,0,30); p.Position = UDim2.new(0,6,0,6); p.BackgroundTransparency = 1; p.ZIndex = 93; Instance.new("UICorner", p).CornerRadius = UDim.new(1,0); loadDP(p, un)
				local nl = Instance.new("TextLabel", c); nl.Size = UDim2.new(1,-50,0,16); nl.Position = UDim2.new(0,44,0,5); nl.BackgroundTransparency = 1; nl.Font = Enum.Font.GothamBold; nl.TextSize = 12; nl.TextColor3 = t.TextColor; nl.TextXAlignment = Enum.TextXAlignment.Left; nl.Text = dn; nl.ZIndex = 93
				local sl = Instance.new("TextLabel", c); sl.Size = UDim2.new(1,-50,0,14); sl.Position = UDim2.new(0,44,0,23); sl.BackgroundTransparency = 1; sl.Font = Enum.Font.GothamMedium; sl.TextSize = 10; sl.TextColor3 = t.SubText; sl.TextXAlignment = Enum.TextXAlignment.Left; sl.Text = "@" .. un; sl.ZIndex = 93
				c.MouseButton1Click:Connect(function() OpenAdminActionModal(un, dn) end)
			end
			for _, p in ipairs(Players:GetPlayers()) do addCard(p.Name, p.DisplayName, p.UserId) end
			for uName, acc in pairs(AxerChat.AccountRegistry) do addCard(acc.Username, acc.DisplayName, acc.UserId) end
		end
		SearchBar:GetPropertyChangedSignal("Text"):Connect(function() RenderAdminCards(SearchBar.Text) end)

		AdminBtn.MouseButton1Click:Connect(function()
			if StickerTray.Visible then StickerTray.Visible=false end; if ImageTray.Visible then ImageTray.Visible=false end
			AdminTray.Visible = not AdminTray.Visible; if AdminTray.Visible then SearchBar.Text = ""; RenderAdminCards() end
		end)
		AxerChat.UI.AdminBtn = AdminBtn; AxerChat.UI.AdminTray = AdminTray; AxerChat.UI.AdminSearch = SearchBar; AxerChat.UI.AdminKwBar = kwBar
	end

	ImageBtn.MouseButton1Click:Connect(function() if StickerTray.Visible then StickerTray.Visible=false end; if AxerChat.UI.AdminTray and AxerChat.UI.AdminTray.Visible then AxerChat.UI.AdminTray.Visible=false end; ImageTray.Visible = not ImageTray.Visible; if ImageTray.Visible then AxerChat.RefreshVaultUI() end end)
	StickerBtn.MouseButton1Click:Connect(function() if ImageTray.Visible then ImageTray.Visible=false end; if AxerChat.UI.AdminTray and AxerChat.UI.AdminTray.Visible then AxerChat.UI.AdminTray.Visible=false end; StickerTray.Visible = not StickerTray.Visible end)

	SaveImgBtn.MouseButton1Click:Connect(function()
		local ru = UrlBox.Text:match("^%s*(.-)%s*$"); if not ru or ru=="" then return end
		UrlBox.Text = ""; local cl = GetDiskVault(); local idp=false
		for _, u in ipairs(cl) do if u == ru then idp=true break end end
		if not idp then table.insert(cl, ru); SaveDiskVault(cl); AxerChat.TriggerToast("✅ Secure Vault", "Image saved forever!", false); AxerChat.RefreshVaultUI()
		else AxerChat.TriggerToast("⚠️ Notice", "Image already saved.", false) end
	end)

	AxerChat.UI.MainBg = MainFrame; AxerChat.UI.MainStroke = MainStroke; AxerChat.UI.HeaderBg = Header; AxerChat.UI.Scroll = Scroll; AxerChat.UI.JumpBtn = JumpBtn; AxerChat.UI.InputWrapper = InputWrapper; AxerChat.UI.TextBox = TextBox; AxerChat.UI.SendBtn = SendBtn; AxerChat.UI.StickerBtn = StickerBtn; AxerChat.UI.ImageBtn = ImageBtn; AxerChat.UI.StickerTray = StickerTray; AxerChat.UI.ImageTray = ImageTray; AxerChat.UI.InboxBtn = InboxBtn; AxerChat.UI.ThemeBtn = ThemeBtn; AxerChat.UI.MuteBtn = MuteBtn; AxerChat.UI.SearchWrapper = SearchWrapper; AxerChat.UI.SearchInput = SearchInput; AxerChat.UI.Title = Title; AxerChat.UI.Back = BackBtn; AxerChat.UI.HeaderDP = HeaderDP; AxerChat.UI.ReplyPreview = ReplyPreview; AxerChat.UI.ReplyIcon = ReplyIcon; AxerChat.UI.ReplyText = ReplyText; AxerChat.UI.CancelRep = CancelRep
	AxerChat.SyncNativeRobloxBubbleSettings()
	if AxerChat.IsLocked then AxerChat.SetLockState(true) end
end

function AxerChat.RefreshVaultUI()
	local sc = AxerChat.UI.ImageTray:FindFirstChild("VaultScroll"); if not sc then return end
	for _, c in pairs(sc:GetChildren()) do if c:IsA("ImageButton") then c:Destroy() end end
	if AxerChat.UI.ImageTray:FindFirstChild("EmptyVaultPlaque") then AxerChat.UI.ImageTray.EmptyVaultPlaque:Destroy() end

	local vl = GetDiskVault(); local cnt = #vl
	if cnt == 0 then 
		local emp = Instance.new("TextLabel", AxerChat.UI.ImageTray); emp.Name = "EmptyVaultPlaque"; emp.Size = UDim2.new(1,-16,1,-92); emp.Position = UDim2.new(0,8,0,88); emp.BackgroundTransparency = 1; emp.Font = Enum.Font.GothamMedium; emp.TextSize = 11; emp.TextColor3 = Color3.fromRGB(200,200,200); emp.ZIndex = 72; emp.RichText = true
		emp.Text = "📂 Vault is currently empty!\nPaste a link above and click Save.\n\n<font color='#B43CFF'>👉 Confused? Type <b>/helpphoto</b> in chat!</font>"
		sc.CanvasSize = UDim2.new(0,0,0,100); return 
	end

	sc.CanvasSize = UDim2.new(0,0,0, math.max(120, (math.ceil(cnt/4)*66)+20))
	for idx, imgUrl in ipairs(vl) do
		local btn = Instance.new("ImageButton", sc); btn.Name = "VaultTile_"..idx; btn.Size = UDim2.new(0,58,0,58); btn.BackgroundColor3 = Color3.fromRGB(30,30,35); btn.ScaleType = Enum.ScaleType.Fit; btn.LayoutOrder = idx; btn.ZIndex = 72; Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
		ApplyWebImage(btn, imgUrl)
		local del = Instance.new("TextButton", btn); del.Size = UDim2.new(0,18,0,18); del.Position = UDim2.new(1,-15,0,-3); del.BackgroundColor3 = Color3.fromRGB(220,45,45); del.Text = "X"; del.Font = Enum.Font.GothamBold; del.TextSize = 10; del.TextColor3 = Color3.fromRGB(255,255,255); del.ZIndex = 73; Instance.new("UICorner", del).CornerRadius = UDim.new(1,0)
		btn.MouseButton1Click:Connect(function() AxerChat.Send("[MEDIA::"..imgUrl.."::MEDIA]"); AxerChat.UI.ImageTray.Visible=false end)
		del.MouseButton1Click:Connect(function() table.remove(vl, idx); SaveDiskVault(vl); AxerChat.RefreshVaultUI(); AxerChat.TriggerToast("🗑️ Secure Disk", "Photo wiped.", false) end)
	end
end

function AxerChat.DressInboxCard(card, itemKey, snippetText, unreadCount)
	local t = Themes[AxerChat.CurrentTheme]; local sl = card:FindFirstChild("Sub")
	if sl then local cl = GetHumanReadablePreview(snippetText); sl.Text = cl:sub(1,35) .. (#cl>35 and "..." or "") end
	local bd = card:FindFirstChild("AxerUnreadBadge")
	if unreadCount > 0 then
		if not bd then
			bd = Instance.new("Frame", card); bd.Name = "AxerUnreadBadge"; bd.Size = UDim2.new(0, 64, 0, 22); bd.Position = UDim2.new(1, -74, 0.5, -11); bd.BackgroundColor3 = t.Accent; Instance.new("UICorner", bd).CornerRadius = UDim.new(0, 6)
			local bt = Instance.new("TextLabel", bd); bt.Name = "Txt"; bt.Size = UDim2.new(1,0,1,0); bt.BackgroundTransparency = 1; bt.Font = Enum.Font.GothamBold; bt.TextSize = 10; bt.TextColor3 = Color3.fromRGB(255,255,255)
		end
		bd.Txt.Text = (unreadCount >= 4) and "4+ New Msgs" or tostring(unreadCount) .. " New Msg"; card.BackgroundColor3 = t.Accent; card.BackgroundTransparency = 0.85
	else if bd then bd:Destroy() end card.BackgroundColor3 = t.OtherBubble; card.BackgroundTransparency = t.BubOtherTrans end
end

function AxerChat.RenderInboxCard(displayName, realUsername, partnerDbKey, lastMsgSnippet)
	local t = Themes[ThemeSequence[currentThemeIndex]]
	local Card = Instance.new("TextButton", AxerChat.UI.Scroll); Card.Name = "DM_Card_" .. partnerDbKey; Card.Size = UDim2.new(1,0,0,48); Card.BackgroundColor3 = t.OtherBubble; Card.BackgroundTransparency = t.BubOtherTrans; Card.Text = ""; Instance.new("UICorner", Card).CornerRadius = UDim.new(0,12)
	local DP = Instance.new("ImageLabel", Card); DP.Size = UDim2.new(0,34,0,34); DP.Position = UDim2.new(0,7,0,7); DP.BackgroundTransparency = 1; loadDP(DP, realUsername); Instance.new("UICorner", DP).CornerRadius = UDim.new(1,0)
	local NameL = Instance.new("TextLabel", Card); NameL.Name = "CardName"; NameL.Size = UDim2.new(1,-60,0,18); NameL.Position = UDim2.new(0,50,0,5); NameL.BackgroundTransparency = 1; NameL.Font = Enum.Font.GothamBold; NameL.TextSize = 13; NameL.TextColor3 = t.TextColor; NameL.TextXAlignment = Enum.TextXAlignment.Left; NameL.Text = displayName .. " (@" .. realUsername .. ")"
	local SnipL = Instance.new("TextLabel", Card); SnipL.Name = "Sub"; SnipL.Size = UDim2.new(1,-60,0,16); SnipL.Position = UDim2.new(0,50,0,25); BackgroundTransparency = 1; SnipL.Font = Enum.Font.GothamMedium; SnipL.TextSize = 11; SnipL.TextColor3 = t.SubText; SnipL.TextXAlignment = Enum.TextXAlignment.Left
	Card.MouseButton1Click:Connect(function() AxerChat.SwitchMode("DM", partnerDbKey) end)
	AxerChat.DressInboxCard(Card, partnerDbKey, lastMsgSnippet, AxerChat.GetUnreadCount(partnerDbKey))
end

function AxerChat.RenderUserSearchCard(displayName, realUserName, userId)
	local t = Themes[ThemeSequence[currentThemeIndex]]
	local Card = Instance.new("Frame", AxerChat.UI.Scroll); Card.Name = "SearchCard_" .. realUserName; Card.Size = UDim2.new(1,0,0,52); Card.BackgroundColor3 = t.OtherBubble; Card.BackgroundTransparency = t.BubOtherTrans; Instance.new("UICorner", Card).CornerRadius = UDim.new(0,12); Instance.new("UIStroke", Card).Color = t.StrokeColor
	local DP = Instance.new("ImageLabel", Card); DP.Size = UDim2.new(0,36,0,36); DP.Position = UDim2.new(0,8,0,8); DP.BackgroundTransparency = 1; Instance.new("UICorner", DP).CornerRadius = UDim.new(1,0); DP.Image = "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=48&h=48"
	local DispL = Instance.new("TextLabel", Card); DispL.Name = "Disp"; DispL.Size = UDim2.new(1,-150,0,18); DispL.Position = UDim2.new(0,54,0,7); DispL.BackgroundTransparency = 1; DispL.Font = Enum.Font.GothamBold; DispL.TextSize = 13; DispL.TextColor3 = t.TextColor; DispL.TextXAlignment = Enum.TextXAlignment.Left; DispL.Text = displayName
	local UserL = Instance.new("TextLabel", Card); UserL.Name = "User"; UserL.Size = UDim2.new(1,-150,0,16); UserL.Position = UDim2.new(0,54,0,27); UserL.BackgroundTransparency = 1; UserL.Font = Enum.Font.GothamMedium; UserL.TextSize = 11; UserL.TextColor3 = t.SubText; UserL.TextXAlignment = Enum.TextXAlignment.Left; UserL.Text = "@" .. realUserName
	local DMBtn = Instance.new("TextButton", Card); DMBtn.Size = UDim2.new(0,68,0,30); DMBtn.Position = UDim2.new(1,-76,0.5,-15); DMBtn.BackgroundColor3 = t.Accent; DMBtn.Font = Enum.Font.GothamBold; DMBtn.TextSize = 12; DMBtn.TextColor3 = Color3.fromRGB(255,255,255); DMBtn.Text = "DM 💬"; Instance.new("UICorner", DMBtn).CornerRadius = UDim.new(0,8)
	DMBtn.MouseButton1Click:Connect(function() local tl = realUserName:lower(); AxerChat.RegisterAccount(realUserName, displayName, userId); AxerChat.Cache.DMs[tl] = AxerChat.Cache.DMs[tl] or {}; AxerChat.SwitchMode("DM", tl); AxerChat.UI.SearchInput.Text = "" end)
end

function AxerChat.TriggerToast(head, snip, isDM, dmTargetDbKey, senderUsername)
	local t = Themes[ThemeSequence[currentThemeIndex]]
	local Card = Instance.new("Frame"); Card.Size = UDim2.new(1, 0, 0, 54); Card.BackgroundColor3 = t.HeaderBg; Card.BackgroundTransparency = 1; Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 12)
	local Stroke = Instance.new("UIStroke", Card); Stroke.Color = isDM and Color3.fromRGB(0, 220, 115) or t.Accent; Stroke.Transparency = 1
	local Txt = Instance.new("TextLabel", Card); Txt.Size = UDim2.new(1, -20, 1, 0); Txt.Position = UDim2.new(0, 10, 0, 0); Txt.BackgroundTransparency = 1; Txt.Font = Enum.Font.GothamMedium; Txt.TextSize = 12; Txt.TextColor3 = t.TextColor; Txt.TextTransparency = 1; Txt.TextXAlignment = Enum.TextXAlignment.Left; Txt.RichText = true
	Txt.Text = string.format("<b>%s</b>\n<font color='#888888'>%s</font>", head, GetHumanReadablePreview(snip):sub(1,30))
	local dpImg = nil
	if senderUsername then
		Txt.Size = UDim2.new(1, -56, 1, 0); Txt.Position = UDim2.new(0, 50, 0, 0)
		dpImg = Instance.new("ImageLabel", Card); dpImg.Size = UDim2.new(0, 34, 0, 34); dpImg.Position = UDim2.new(0, 8, 0.5, -17); dpImg.BackgroundTransparency = 1; dpImg.ImageTransparency = 1; Instance.new("UICorner", dpImg).CornerRadius = UDim.new(1, 0); loadDP(dpImg, senderUsername)
	end
	Card.Parent = ToastFrame
	TweenService:Create(Card, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = t.HeadTrans}):Play(); TweenService:Create(Stroke, TweenInfo.new(0.35), {Transparency = 0}):Play(); TweenService:Create(Txt, TweenInfo.new(0.35), {TextTransparency = 0}):Play()
	if dpImg then TweenService:Create(dpImg, TweenInfo.new(0.35), {ImageTransparency = 0}):Play() end
	if isDM and dmTargetDbKey then
		local Btn = Instance.new("TextButton", Card); Btn.Size = UDim2.new(1, 0, 1, 0); Btn.BackgroundTransparency = 1; Btn.Text = ""
		Btn.MouseButton1Click:Connect(function() AxerChat.SwitchMode("DM", dmTargetDbKey); if not AxerChat.UI.MainBg.Visible then AxerChat.UI.MainBg.Visible = true end; Card:Destroy() end)
	end
	task.spawn(function() task.wait(4); if Card.Parent then local tw = TweenService:Create(Card, TweenInfo.new(0.3), {BackgroundTransparency = 1}); TweenService:Create(Txt, TweenInfo.new(0.3), {TextTransparency = 1}); Stroke.Transparency = 1; if dpImg then dpImg.ImageTransparency = 1 end; Card:Destroy() end end)
end

function AxerChat.TriggerArrivalToast(arrName)
	local Card = Instance.new("Frame"); Card.Size = UDim2.new(1, 0, 0, 58); Card.BackgroundColor3 = Color3.fromRGB(28,10,45); Instance.new("UICorner", Card).CornerRadius = UDim.new(0,12)
	local Stroke = Instance.new("UIStroke", Card); Stroke.Color = Color3.fromRGB(180,60,255); Stroke.Thickness = 1.5
	local dpImg = Instance.new("ImageLabel", Card); dpImg.Size = UDim2.new(0, 34, 0, 34); dpImg.Position = UDim2.new(0, 10, 0.5, -17); dpImg.BackgroundTransparency = 1; dpImg.ImageTransparency = 1; dpImg.Image = "rbxassetid://92917449577250"; Instance.new("UICorner", dpImg).CornerRadius = UDim.new(1, 0)
	local Txt = Instance.new("TextLabel", Card); Txt.Size = UDim2.new(1,-58,1,0); Txt.Position = UDim2.new(0,54,0,0); Txt.BackgroundTransparency = 1; Txt.Font = Enum.Font.GothamMedium; Txt.TextSize = 11; Txt.TextColor3 = Color3.fromRGB(255,255,255); Txt.TextXAlignment = Enum.TextXAlignment.Left; Txt.RichText = true; Txt.TextTransparency = 1
	Txt.Text = "<font color='#B43CFF'><b>ARIA</b></font>\nWelcome dear <b>" .. arrName .. "</b>!"
	Card.Parent = ToastFrame; TweenService:Create(Card, TweenInfo.new(0.35, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundTransparency=0.1}):Play(); TweenService:Create(Txt, TweenInfo.new(0.35), {TextTransparency=0}):Play(); TweenService:Create(dpImg, TweenInfo.new(0.35), {ImageTransparency=0}):Play()
	task.spawn(function() task.wait(5.0); if Card.Parent then local tw=TweenService:Create(Card, TweenInfo.new(0.4), {BackgroundTransparency=1}); TweenService:Create(Txt, TweenInfo.new(0.4), {TextTransparency=1}); Stroke.Transparency = 1; dpImg.ImageTransparency = 1; tw:Play(); tw.Completed:Wait(); Card:Destroy() end end)
end

local function ApplyPreciseTimelineCurvedTitle(dpImage, textString)
	if not dpImage or not dpImage.Parent then return end
	local pf = dpImage.Parent; local Arc = pf:FindFirstChild("AxerCurvedTitleArc"); if Arc then Arc:Destroy() end
	Arc = Instance.new("Frame"); Arc.Name = "AxerCurvedTitleArc"; Arc.Size = dpImage.Size; Arc.Position = dpImage.Position; Arc.AnchorPoint = dpImage.AnchorPoint; Arc.BackgroundTransparency = 1; Arc.ZIndex = dpImage.ZIndex + 5; Arc.Parent = pf
	local cc = #textString; local br = (dpImage.Size.X.Offset / 2) + 3.5; local sa = math.rad(-90 - (math.min((cc-1)*18, 160)/2)); local ea = math.rad(-90 + (math.min((cc-1)*18, 160)/2)); local cx, cy = dpImage.Size.X.Offset/2, dpImage.Size.Y.Offset/2
	local lTrack = {}
	for i = 1, cc do
		local curA = (cc > 1) and (sa + ((i-1)*(ea-sa)/(cc-1))) or sa
		local L = Instance.new("TextLabel", Arc); L.Size = UDim2.new(0, 14, 0, 14); L.AnchorPoint = Vector2.new(0.5, 0.5); L.Position = UDim2.new(0, cx + (math.cos(curA)*br), 0, cy + (math.sin(curA)*br)); L.BackgroundTransparency = 1; L.Text = textString:sub(i,i); L.Font = Enum.Font.GothamBold; L.TextSize = 8.5; L.TextColor3 = Color3.fromRGB(255, 255, 255); L.TextXAlignment = Enum.TextXAlignment.Center; L.Rotation = math.deg(curA) + 90
		local ug = Instance.new("UIGradient", L); ug.Rotation = 45; ug.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 195, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 60, 255))})
		table.insert(lTrack, {l = L, idx = i})
	end
	local tc = 10.0; local con
	con = RunService.Heartbeat:Connect(function()
		if not Arc or not Arc.Parent or getgenv().AxerChat_Unloading then con:Disconnect() return end
		local t = os.clock()
		for _, d in ipairs(lTrack) do
			local lt = (t - (d.idx * 0.22)) % tc
			d.l.TextTransparency = (lt < 5.0) and 0 or ((lt < 6.0) and ((1-math.cos((lt-5.0)*math.pi))/2) or ((lt < 9.0) and 1 or ((1+math.cos((lt-9.0)*math.pi))/2)))
		end
	end)
end

function AxerChat.LiveSyncAllVisibleBubblesVIP()
	for _, child in pairs(AxerChat.UI.Scroll:GetChildren()) do
		if child:IsA("Frame") and child:FindFirstChild("MessageBubble") then
			local bub = child.MessageBubble; local sn = ""; local nl = bub:FindFirstChild("SenderName")
			if nl then sn = nl.Text elseif bub.AnchorPoint.X == 1 then sn = LocalPlayer.Name end
			local sl = sn:lower()
			local isV = (sl == "venus_edit") or (AxerChat.VIPList and AxerChat.VIPList[sl]) or (bub.AnchorPoint.X == 1 and LocalPlayer.UserId == 7169032620)
			if isV then bub:SetAttribute("IsVIPBubble", true); ApplyVIPStyleToBubble(bub, AxerChat.CurrentTheme) end
		end
	end
end

function AxerChat.LiveSyncAllVisibleBubblesTitle()
	for _, child in pairs(AxerChat.UI.Scroll:GetChildren()) do
		if child:IsA("Frame") and child:FindFirstChild("MessageBubble") then
			local dp = child:FindFirstChildWhichIsA("ImageLabel"); local bub = child.MessageBubble
			if dp and bub then
				local sn = ""; local nl = bub:FindFirstChild("SenderName")
				if nl then sn = nl.Text elseif bub.AnchorPoint.X == 1 then sn = LocalPlayer.Name end
				local ast = AxerChat.TitleRegistry[sn:lower()] or ((bub.AnchorPoint.X == 1 and LocalPlayer.UserId == 7169032620) and "CREATOR" or nil)
				if ast then ApplyPreciseTimelineCurvedTitle(dp, ast) else if dp.Parent:FindFirstChild("AxerCurvedTitleArc") then dp.Parent.AxerCurvedTitleArc:Destroy() end end
			end
		end
	end
end

function AxerChat.RenderBubble(senderUsername, rawUserId, rawText, timestamp, msg_id, isEditedFlag)
	local t = Themes[ThemeSequence[currentThemeIndex]]; local isMe = (string.lower(senderUsername) == string.lower(LocalPlayer.Name)); local isAria = (senderUsername == "ARIA")
	local repUser, repSnippet, cleanText = rawText:match("^%[RPL::(.-)::(.-)::RPL%]%s*(.*)"); if not repUser then cleanText = rawText end
	local isEdt = isEditedFlag or false; if cleanText:sub(1,5) == "[EDT]" then isEdt = true; cleanText = cleanText:sub(6) end

	local Wrap = Instance.new("Frame", AxerChat.UI.Scroll); Wrap.Size = UDim2.new(1,0,0,0); Wrap.AutomaticSize = Enum.AutomaticSize.Y; Wrap.BackgroundTransparency = 1
	if msg_id then AxerChat.ActiveBubbleNodes[msg_id] = Wrap end

	local DP = Instance.new("ImageLabel", Wrap); DP.Size = isAria and UDim2.new(0,32,0,32) or UDim2.new(0,26,0,26); DP.BackgroundTransparency = 1; loadDP(DP, senderUsername); Instance.new("UICorner", DP).CornerRadius = UDim.new(1,0); DP.AnchorPoint = isMe and Vector2.new(1,0) or Vector2.new(0,0); DP.Position = isMe and UDim2.new(1,0,0,0) or UDim2.new(0,0,0,0)

	local sl = senderUsername:lower()
	local isV = (tonumber(rawUserId) == 7169032620) or (sl == "venus_edit") or (AxerChat.VIPList and AxerChat.VIPList[sl])
	if not isAria then
		local at = AxerChat.TitleRegistry[sl] or ((tonumber(rawUserId) == 7169032620) or (sl == "venus_edit") and "CREATOR" or nil)
		if at then ApplyPreciseTimelineCurvedTitle(DP, at) end
	end

	local basePos = isMe and UDim2.new(1,-34,0,0) or (isAria and UDim2.new(0,42,0,0) or UDim2.new(0,34,0,0))
	local SwipeIcon = Instance.new("TextLabel", Wrap); SwipeIcon.Size=UDim2.new(0,30,0,30); SwipeIcon.BackgroundTransparency=1; SwipeIcon.Position=isMe and UDim2.new(0,-15,0.5,-15) or UDim2.new(1,-15,0.5,-15); SwipeIcon.Text="↩"; SwipeIcon.Font=Enum.Font.GothamBold; SwipeIcon.TextSize=16; SwipeIcon.TextColor3=t.SubText; SwipeIcon.TextTransparency=1

	local Bub = Instance.new("Frame", Wrap); Bub.Name = "MessageBubble"; Bub.AutomaticSize=Enum.AutomaticSize.XY; Bub.AnchorPoint=isMe and Vector2.new(1,0) or Vector2.new(0,0); Bub.Position=basePos; Bub.Active=true; Instance.new("UICorner", Bub).CornerRadius=UDim.new(0,14); Instance.new("UISizeConstraint", Bub).MaxSize=Vector2.new(330,9999)
	local BLayout = Instance.new("UIListLayout", Bub); BLayout.Padding=UDim.new(0,3); BLayout.SortOrder=Enum.SortOrder.LayoutOrder
	local Pad = Instance.new("UIPadding", Bub); Pad.PaddingTop=UDim.new(0,6); Pad.PaddingBottom=UDim.new(0,6); Pad.PaddingLeft=UDim.new(0,14); Pad.PaddingRight=UDim.new(0,14)
	Bub:SetAttribute("LiveText", cleanText)

	if not isMe then
		local acc = AxerChat.GetAccount(senderUsername)
		local N = Instance.new("TextLabel", Bub); N.Name="SenderName"; N.AutomaticSize=Enum.AutomaticSize.XY; N.BackgroundTransparency=1; N.Font=Enum.Font.GothamBold; N.TextSize=isAria and 12 or 10; N.TextColor3=isAria and Color3.fromRGB(180,60,255) or t.NameColor; N.Text=isAria and "ARIA" or acc.DisplayName; N.LayoutOrder=1
	end

	if repUser then
		local gAcc = AxerChat.GetAccount(repUser); local Ghost = Instance.new("Frame", Bub); Ghost.AutomaticSize=Enum.AutomaticSize.XY; Ghost.BackgroundColor3=t.TextColor; Ghost.BackgroundTransparency=0.88; Ghost.LayoutOrder=2; Instance.new("UICorner", Ghost).CornerRadius=UDim.new(0,6); local GPad=Instance.new("UIPadding", Ghost); GPad.PaddingLeft=UDim.new(0,12); GPad.PaddingRight=UDim.new(0,8); GPad.PaddingTop=UDim.new(0,4); GPad.PaddingBottom=UDim.new(0,4); local Line=Instance.new("Frame", Ghost); Line.Size=UDim2.new(0,3,1,0); Line.Position=UDim2.new(0,-8,0,0); Line.BackgroundColor3=t.Accent; Line.BackgroundTransparency=0.1; Line.BorderSizePixel=0; Instance.new("UICorner", Line).CornerRadius=UDim.new(0,2); local GTxt=Instance.new("TextLabel", Ghost); GTxt.AutomaticSize=Enum.AutomaticSize.XY; GTxt.BackgroundTransparency=1; GTxt.Font=Enum.Font.GothamMedium; GTxt.TextSize=10; GTxt.TextColor3=t.TextColor; GTxt.TextTransparency=0.1; GTxt.RichText=true; GTxt.Text=string.format("<b>%s</b>\n%s", gAcc.DisplayName, repSnippet)
	end

	local stkId = cleanText:match("%[STICKER://(%d+)%]"); local mediaUrl = cleanText:match("%[MEDIA::(.-)::MEDIA%]")
	if stkId then 
		local StkBox = Instance.new("ImageLabel", Bub); StkBox.Size=UDim2.new(0,115,0,115); StkBox.BackgroundTransparency=1; StkBox.Image="rbxthumb://type=Asset&id="..stkId.."&w=150&h=150"; StkBox.ScaleType=Enum.ScaleType.Fit; StkBox.LayoutOrder=3
	elseif mediaUrl then
		local ImgBox = Instance.new("ImageButton", Bub)
		ImgBox.Name="MiniPhotoCard"
		ImgBox.Size = UDim2.new(0,195,0,150)
		ImgBox.BackgroundTransparency = 1
		ImgBox.ScaleType = Enum.ScaleType.Fit
		ImgBox.LayoutOrder = 3
		ApplyWebImage(ImgBox, mediaUrl)
		ImgBox.MouseButton1Click:Connect(function()
			if Screen:FindFirstChild("AxerFullscreenViewerModal") then return end
			local blur = Instance.new("BlurEffect", Lighting); blur.Name = "AxerCinematicBlur"; blur.Size = 22; local Modal = Instance.new("Frame", Screen); Modal.Name = "AxerFullscreenViewerModal"; Modal.Size = UDim2.new(1,0,1,0); Modal.BackgroundColor3 = Color3.fromRGB(0,0,0); Modal.BackgroundTransparency = 0.35; Modal.Active = true; Modal.ZIndex = 1000
			local BigImg = Instance.new("ImageLabel", Modal); BigImg.Size = UDim2.new(0.85,0,0.85,0); BigImg.Position = UDim2.new(0.5,0,0.5,0); BigImg.AnchorPoint = Vector2.new(0.5,0.5); BigImg.BackgroundTransparency = 1; BigImg.ScaleType = Enum.ScaleType.Fit; BigImg.ZIndex = 1001; ApplyWebImage(BigImg, mediaUrl)
			local CloseBtn = Instance.new("TextButton", Modal); CloseBtn.Size = UDim2.new(0,44,0,44); CloseBtn.Position = UDim2.new(1,-58,0,35); CloseBtn.BackgroundColor3 = Color3.fromRGB(20,20,25); CloseBtn.Text = "X"; CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 22; CloseBtn.TextColor3 = Color3.fromRGB(255,255,255); CloseBtn.ZIndex = 1002; Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1,0)
			CloseBtn.MouseButton1Click:Connect(function() if Lighting:FindFirstChild("AxerCinematicBlur") then Lighting.AxerCinematicBlur:Destroy() end; Modal:Destroy() end)
		end)
	else 
		local MsgTxt = Instance.new("TextLabel", Bub); MsgTxt.Name="MainMessageText"; MsgTxt.AutomaticSize=Enum.AutomaticSize.XY; MsgTxt.BackgroundTransparency=1; MsgTxt.Font=Enum.Font.GothamMedium; MsgTxt.TextSize=13; MsgTxt.TextColor3=t.TextColor; MsgTxt.TextWrapped=true; MsgTxt.RichText=true; MsgTxt.TextXAlignment=Enum.TextXAlignment.Left; MsgTxt.Text=isEdt and (cleanText.."\n<font color='#888888' size='10'><i>(edited)</i></font>") or cleanText; MsgTxt.LayoutOrder=3 
	end

	local bgCol = isMe and t.MyBubble or t.OtherBubble
	local bgTrans = isMe and t.BubMeTrans or t.BubOtherTrans

	Bub.BackgroundColor3 = bgCol
	Bub.BackgroundTransparency = bgTrans
	if isV then
		Bub:SetAttribute("IsVIPBubble", true)
		ApplyVIPStyleToBubble(Bub, AxerChat.CurrentTheme)
	else
		local msgLbl = Bub:FindFirstChild("MainMessageText")
		if msgLbl then msgLbl.TextColor3 = t.TextColor end
		local nameLbl = Bub:FindFirstChild("SenderName")
		if nameLbl and nameLbl.Text ~= "ARIA" then
			nameLbl.TextColor3 = t.NameColor
		end
	end

	local isHolding = false
	Bub.InputBegan:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then if isAria then return end; isHolding=true; task.delay(1.0, function() if isHolding and Bub.Parent then isHolding=false; AxerChat.OpenActionMenu(senderUsername, rawUserId, Bub:GetAttribute("LiveText") or cleanText, msg_id, isMe) end end) end end)
	Bub.InputEnded:Connect(function() isHolding=false end)

	local dragBub, sX = false, 0
	Bub.InputBegan:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then if not isAria and not AxerChat.ActiveSwipeBubble then AxerChat.ActiveSwipeBubble=Bub; dragBub=true; sX=inp.Position.X end end end)
	UserInputService.InputChanged:Connect(function(inp) if dragBub and AxerChat.ActiveSwipeBubble==Bub then if inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then isHolding=false; local d=inp.Position.X-sX; if isMe and d<0 then local mX=math.max(d,-60); Bub.Position=basePos+UDim2.new(0,mX,0,0); SwipeIcon.TextTransparency=1-(math.abs(mX)/45) elseif not isMe and d>0 then local mX=math.min(d,60); Bub.Position=basePos+UDim2.new(0,mX,0,0); SwipeIcon.TextTransparency=1-(mX/45) end end end end)
	UserInputService.InputEnded:Connect(function(inp) if dragBub and AxerChat.ActiveSwipeBubble==Bub then if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then dragBub=false; AxerChat.ActiveSwipeBubble=nil; local d=inp.Position.X-sX; if (isMe and d<=-40) or (not isMe and d>=40) then AxerChat.SetReply(senderUsername, Bub:GetAttribute("LiveText") or cleanText, AxerChat.GetAccount(senderUsername).DisplayName) end; TweenService:Create(Bub, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position=basePos}):Play(); TweenService:Create(SwipeIcon, TweenInfo.new(0.2), {TextTransparency=1}):Play() end end end)

	DP.InputBegan:Connect(function(inp) if (inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch) and not isMe and not isAria then AxerChat.SwitchMode("DM", senderUsername:lower()) end end)
	AxerChat.HandleScroll(isMe)
end

function AxerChat.OpenActionMenu(senderUsername, rawUserId, cleanText, msg_id, isMe)
	if senderUsername == "ARIA" or AxerChat.UI.MainBg:FindFirstChild("AxerHoldActionMenu") then return end
	local acc = AxerChat.GetAccount(senderUsername); local trueDispName = acc.DisplayName; local rawMenuText = (cleanText:sub(1,5) == "[EDT]") and cleanText:sub(6) or cleanText; local t = Themes[ThemeSequence[currentThemeIndex]]
	local Overlay = Instance.new("Frame", AxerChat.UI.MainBg); Overlay.Name = "AxerHoldActionMenu"; Overlay.Size = UDim2.new(1,0,1,0); Overlay.BackgroundColor3 = Color3.fromRGB(0,0,0); Overlay.BackgroundTransparency = 1; Overlay.Active = true; Overlay.ZIndex = 85
	local isMedia = rawMenuText:match("^%[STICKER://") or rawMenuText:match("^%[MEDIA::"); local btnCount = 3; if isMe and msg_id then btnCount = btnCount + (isMedia and 1 or 2) end
	local Box = Instance.new("Frame", Overlay); Box.Size = UDim2.new(0, 260, 0, 75 + (btnCount * 34)); Box.Position = UDim2.new(0.5, 0, 0.5, 0); Box.AnchorPoint = Vector2.new(0.5, 0.5); Box.BackgroundColor3 = t.HeaderBg; Box.BackgroundTransparency = t.HeadTrans; Box.ZIndex = 86; Box.ClipsDescendants = true; Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 14); Instance.new("UIStroke", Box).Color = t.Accent
	local Layout = Instance.new("UIListLayout", Box); Layout.Padding = UDim.new(0, 4); Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center; Layout.SortOrder = Enum.SortOrder.LayoutOrder; Instance.new("UIPadding", Box).PaddingTop = UDim.new(0, 10)
	local Title = Instance.new("TextLabel", Box); Title.Size = UDim2.new(1, -20, 0, 22); Title.BackgroundTransparency = 1; Title.Font = Enum.Font.GothamBold; Title.TextSize = 12; Title.TextColor3 = t.SubText; Title.LayoutOrder = 1; Title.ZIndex = 87; Title.Text = "Options (" .. trueDispName .. ")"
	local desc = GetHumanReadablePreview(rawMenuText); local Snip = Instance.new("TextLabel", Box); Snip.Size = UDim2.new(1, -20, 0, 32); Snip.BackgroundTransparency = 1; Snip.Font = Enum.Font.GothamMedium; Snip.TextSize = 11; Snip.TextColor3 = t.TextColor; Snip.TextWrapped = true; Snip.LayoutOrder = 2; Snip.ZIndex = 87; Snip.Text = (desc == rawMenuText) and ('"' .. rawMenuText:sub(1,36) .. '..."') or desc

	local curOrder = 3
	local function makeBtn(name, icon, bgCol, action)
		local b = Instance.new("TextButton", Box); b.Size = UDim2.new(1, -30, 0, 30); b.BackgroundColor3 = bgCol; b.BackgroundTransparency = 0.15; b.Font = Enum.Font.GothamBold; b.TextSize = 12; b.TextColor3 = Color3.fromRGB(255,255,255); b.LayoutOrder = curOrder; b.ZIndex = 87; b.Text = icon .. " " .. name; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
		b.MouseButton1Click:Connect(function() action(); Overlay:Destroy() end); curOrder = curOrder + 1
	end

	makeBtn("Copy Text", "📋", Color3.fromRGB(35,110,200), function() local cp = setclipboard or toclipboard; if cp then cp(rawMenuText); AxerChat.TriggerToast("📋 Copied", "Text saved", false) end end)
	if isMe and msg_id and not isMedia then makeBtn("Edit Message", "✏️", Color3.fromRGB(210,130,30), function() AxerChat.StartEditing(msg_id, rawMenuText) end) end
	makeBtn("Reply", "↩️", t.Accent, function() AxerChat.SetReply(senderUsername, rawMenuText, trueDispName) end)
	if isMe and msg_id then makeBtn("Unsend", "🗑️", Color3.fromRGB(210,45,45), function() AxerChat.UnsendMsg(msg_id) end) end
	makeBtn("Cancel", "X", Color3.fromRGB(70,70,70), function() end)
	TweenService:Create(Overlay, TweenInfo.new(0.18), {BackgroundTransparency=0.5}):Play()
end

function AxerChat.UnsendMsg(msg_id)
	local myLower = LocalPlayer.Name:lower(); local hisLower = AxerChat.ActiveDM and AxerChat.ActiveDM:lower() or ""
	task.spawn(function()
		if AxerChat.Mode == "DM" and hisLower ~= "" then pcall(function() httprequest({Url=STATIC_PROXY.."DMs/"..myLower.."/"..hisLower.."/"..msg_id..".json", Method="DELETE"}); httprequest({Url=STATIC_PROXY.."DMs/"..hisLower.."/"..myLower.."/"..msg_id..".json", Method="DELETE"}) end)
		else pcall(function() httprequest({Url=STATIC_PROXY.."Srv/"..REAL_JOB_ID.."/"..msg_id..".json", Method="DELETE"}) end) end
	end)
	AxerChat.TriggerToast("🗑️ Unsent", "Message recalled globally", false)
	if AxerChat.ActiveBubbleNodes[msg_id] then AxerChat.ActiveBubbleNodes[msg_id]:Destroy(); AxerChat.ActiveBubbleNodes[msg_id] = nil end
end

function AxerChat.StartEditing(msg_id, old_text)
	AxerChat.EditingMsgID = msg_id; AxerChat.UI.TextBox.Text = old_text; AxerChat.UI.ReplyIcon.Text = "✏️"; AxerChat.UI.ReplyText.Text = "Editing your message...\n" .. old_text:sub(1,28)
	AxerChat.UI.ReplyPreview.Visible = true; TweenService:Create(AxerChat.UI.ReplyPreview, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position=UDim2.new(0,10,1,-84)}):Play(); AxerChat.UI.TextBox:CaptureFocus()
end

function AxerChat.SetReply(senderUsername, text, senderTrueDisplayName)
	local snip = GetHumanReadablePreview(text); if #snip > 28 and not snip:match("^%[") then snip=snip:sub(1,28).."..." end
	AxerChat.ReplyingTo = {Username = senderUsername, DispName = senderTrueDisplayName, Text = snip}; AxerChat.UI.ReplyText.Text = "Replying to <b>" .. senderTrueDisplayName .. "</b>\n" .. snip; AxerChat.UI.ReplyIcon.Text = "↩"
	AxerChat.UI.ReplyPreview.Visible = true; TweenService:Create(AxerChat.UI.ReplyPreview, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position=UDim2.new(0,10,1,-84)}):Play(); AxerChat.UI.TextBox:CaptureFocus()
end

function AxerChat.CancelActionBar()
	AxerChat.ReplyingTo = nil; AxerChat.EditingMsgID = nil; local tw = TweenService:Create(AxerChat.UI.ReplyPreview, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position=UDim2.new(0,10,1,-46)})
	tw:Play(); task.spawn(function() tw.Completed:Wait(); AxerChat.UI.ReplyPreview.Visible=false end)
end

function AxerChat.HandleScroll(forceBottom)
	task.spawn(function()
		RunService.RenderStepped:Wait(); RunService.RenderStepped:Wait()
		local maxS = AxerChat.UI.Scroll.CanvasSize.Y.Offset - AxerChat.UI.Scroll.AbsoluteWindowSize.Y
		if maxS <= 0 then return end
		local hyperGlide = TweenInfo.new(0.38, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		if forceBottom then TweenService:Create(AxerChat.UI.Scroll, hyperGlide, {CanvasPosition = Vector2.new(0, maxS)}):Play(); AxerChat.UI.JumpBtn.Visible = false 
		elseif AxerChat.UI.Scroll.CanvasPosition.Y < (maxS - 50) then AxerChat.UI.JumpBtn.Visible = true 
		else TweenService:Create(AxerChat.UI.Scroll, hyperGlide, {CanvasPosition = Vector2.new(0, maxS)}):Play() end
	end)
end

function AxerChat.LiveUpdateInboxSort()
	if AxerChat.Mode ~= "DM_Inbox" then return end
	local sList = {}
	for pl, msgs in pairs(AxerChat.Cache.DMs) do table.insert(sList, {k = pl, t = msgs[#msgs] and msgs[#msgs].Time or 0, s = msgs[#msgs] and msgs[#msgs].Msg or "Start secure chat...", u = AxerChat.GetUnreadCount(pl)}) end
	table.sort(sList, function(a, b) return a.t > b.t end)
	for idx, item in ipairs(sList) do
		local c = AxerChat.UI.Scroll:FindFirstChild("DM_Card_" .. item.k)
		if c then c.LayoutOrder = idx; AxerChat.DressInboxCard(c, item.k, item.s, item.u) else local acc = AxerChat.GetAccount(item.k); AxerChat.RenderInboxCard(acc.DisplayName, acc.Username, item.k, item.s) end
	end
end

function AxerChat.SwitchMode(mode, targetUsernameLower)
	AxerChat.Mode = mode; AxerChat.ActiveDM = targetUsernameLower and targetUsernameLower:lower() or nil
	for _, c in pairs(AxerChat.UI.Scroll:GetChildren()) do if c:IsA("Frame") or c:IsA("TextButton") then c:Destroy() end end
	AxerChat.ActiveBubbleNodes = {}; AxerChat.MessagesCount = 0

	if mode == "Server" then
		AxerChat.UI.HeaderDP.Visible = false; AxerChat.UI.Title.Text = "AXER CHAT"; AxerChat.UI.Title.Position = UDim2.new(0,15,0,0); AxerChat.UI.Back.Visible=false; AxerChat.UI.InboxBtn.Visible=true; AxerChat.UI.MuteBtn.Visible=true; AxerChat.UI.SearchWrapper.Visible=false; AxerChat.UI.InputWrapper.Visible=true; AxerChat.UI.StickerBtn.Visible=true; AxerChat.UI.ImageBtn.Visible=true; AxerChat.UI.Scroll.Position=UDim2.new(0,0,0,34); AxerChat.UI.Scroll.Size=UDim2.new(1,0,1,-80)
		AxerChat.UI.TextBox.PlaceholderText = AxerChat.IsLocked and "🔒 CHAT LOCKED BY ADMIN" or "Type message..."
		for _, m in pairs(AxerChat.Cache.Server) do 
			-- We no longer have announcements, so just render regular bubbles
			AxerChat.RenderBubble(m.Sender, m.UserID, m.Msg, m.Time, m.ID, m.Edited)
		end
	elseif mode == "DM_Inbox" then
		AxerChat.UI.HeaderDP.Visible = false; AxerChat.UI.Title.Text = "DM Inbox"; AxerChat.UI.Title.Position = UDim2.new(0,35,0,0); AxerChat.UI.Back.Visible=true; AxerChat.UI.InboxBtn.Visible=false; AxerChat.UI.MuteBtn.Visible=false; AxerChat.UI.InputWrapper.Visible=false; AxerChat.UI.ReplyPreview.Visible=false; AxerChat.UI.StickerTray.Visible=false; AxerChat.UI.ImageTray.Visible=false; AxerChat.UI.SearchWrapper.Visible=true; AxerChat.UI.SearchWrapper.Position = UDim2.new(0,10,0,40); AxerChat.UI.Scroll.Position=UDim2.new(0,0,0,82); AxerChat.UI.Scroll.Size=UDim2.new(1,0,1,-88)
		local sList = {}
		for pl, msgs in pairs(AxerChat.Cache.DMs) do local acc = AxerChat.GetAccount(pl); table.insert(sList, {k = pl, d = acc.DisplayName, u = acc.Username, s = msgs[#msgs] and msgs[#msgs].Msg or "Tap to chat...", t = msgs[#msgs] and msgs[#msgs].Time or 0}) end
		table.sort(sList, function(a, b) return a.t > b.t end)
		for idx, item in ipairs(sList) do AxerChat.RenderInboxCard(item.d, item.u, item.k, item.s); local c = AxerChat.UI.Scroll:FindFirstChild("DM_Card_" .. item.k); if c then c.LayoutOrder = idx end end
	elseif mode == "DM" then
		AxerChat.SetLastRead(targetUsernameLower, GetUniverseTimestamp()); local acc = AxerChat.GetAccount(targetUsernameLower); AxerChat.UI.HeaderDP.Visible = true; loadDP(AxerChat.UI.HeaderDP, acc.Username); AxerChat.UI.Title.Text = acc.DisplayName .. " (@" .. acc.Username .. ")"; AxerChat.UI.Title.Position = UDim2.new(0, 68, 0, 0); AxerChat.UI.Back.Visible=true; AxerChat.UI.InboxBtn.Visible=true; AxerChat.UI.MuteBtn.Visible=false; AxerChat.UI.SearchWrapper.Visible=false; AxerChat.UI.InputWrapper.Visible=true; AxerChat.UI.StickerBtn.Visible=true; AxerChat.UI.ImageBtn.Visible=true; AxerChat.UI.Scroll.Position=UDim2.new(0,0,0,34); AxerChat.UI.Scroll.Size=UDim2.new(1,0,1,-80)
		AxerChat.UI.TextBox.PlaceholderText = AxerChat.IsLocked and "🔒 CHAT LOCKED BY ADMIN" or ("DM to " .. acc.DisplayName .. "...")
		if AxerChat.Cache.DMs[targetUsernameLower] then for _, m in pairs(AxerChat.Cache.DMs[targetUsernameLower]) do AxerChat.RenderBubble(m.Sender, m.UserID, m.Msg, m.Time, m.ID, m.Edited) end end
	end
	AxerChat.HandleScroll(true)
end

function AxerChat.Send(txt)
	if AxerChat.IsLocked then return end
	local myLower = LocalPlayer.Name:lower()

	if AxerChat.ReplyingTo then txt = string.format("[RPL::%s::%s::RPL] %s", AxerChat.ReplyingTo.Username, AxerChat.ReplyingTo.Text, txt) end
	local function isImgUrl(s) local l=s:lower() return l:match("^https?://.+") and (l:find("%.png") or l:find("%.jpg") or l:find("%.jpeg") or l:find("%.webp") or l:find("%.gif")) end
	if isImgUrl(txt) and not txt:match("^%[MEDIA::") then txt = "[MEDIA::" .. txt .. "::MEDIA]" end

	local isDM, hisLower = (AxerChat.Mode == "DM"), AxerChat.ActiveDM or ""
	local packetID = "M_" .. LocalPlayer.UserId .. "_" .. os.time() .. "_" .. math.random(1000, 9999)
	local key = isDM and getDMKey(myLower, hisLower) or getSrvPfx() .. REAL_JOB_ID
	
	local ciph, sign = SecureEncrypt(key, txt); local newTime = GetUniverseTimestamp()
	AxerChat.PendingCommitGrace[packetID] = os.clock()
	local payload = HttpService:JSONEncode({ u = LocalPlayer.UserId, s = LocalPlayer.Name, m = ciph, sign = sign, t = newTime })

	if isDM then 
		ExecuteWebPush(STATIC_PROXY.."DMs/"..myLower.."/"..hisLower.."/"..packetID..".json", payload)
		ExecuteWebPush(STATIC_PROXY.."DMs/"..hisLower.."/"..myLower.."/"..packetID..".json", payload)
		AxerChat.SetLastRead(hisLower, newTime)
	else 
		BroadcastToFirebase(LocalPlayer.Name, txt, false, nil)
	end

	AxerChat.SeenIDs[packetID] = sign; local targetCache = isDM and AxerChat.Cache.DMs[hisLower] or AxerChat.Cache.Server
	if targetCache then table.insert(targetCache, {Sender = LocalPlayer.Name, UserID = LocalPlayer.UserId, Msg = txt, Time = newTime, ID = packetID, Edited = false}) end
	if not isDM and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then pcall(function() game:GetService("Chat"):Chat(LocalPlayer.Character.Head, GetHumanReadablePreview(txt), Enum.ChatColor.White) end) end
	AxerChat.RenderBubble(LocalPlayer.Name, LocalPlayer.UserId, txt, newTime, packetID, false)
end

function AxerChat.SubmitEdit(msg_id, new_text)
	local isDM, hisLower = (AxerChat.Mode == "DM"), AxerChat.ActiveDM or ""; local myLower = LocalPlayer.Name:lower()
	local key = isDM and getDMKey(myLower, hisLower) or getSrvPfx() .. REAL_JOB_ID; local ciph, sign = SecureEncrypt(key, "[EDT]" .. new_text); local newTime = GetUniverseTimestamp()
	for _, itm in ipairs((isDM and AxerChat.Cache.DMs[hisLower] or AxerChat.Cache.Server) or {}) do if itm.ID == msg_id then itm.Msg=new_text; itm.Edited=true break end end
	AxerChat.SeenIDs[msg_id] = sign; local payload = HttpService:JSONEncode({ u = LocalPlayer.UserId, s = LocalPlayer.Name, m = ciph, sign = sign, t = newTime })
	if isDM then ExecuteWebPush(STATIC_PROXY.."DMs/"..myLower.."/"..hisLower.."/"..msg_id..".json", payload); ExecuteWebPush(STATIC_PROXY.."DMs/"..hisLower.."/"..myLower.."/"..msg_id..".json", payload)
	else 
		-- For server, edits are not synced to Firebase (to keep it simple), but local cache is updated.
	end
	local node = AxerChat.ActiveBubbleNodes[msg_id]; if node and node:FindFirstChild("MessageBubble") then node.MessageBubble:SetAttribute("LiveText", new_text); if node.MessageBubble:FindFirstChild("MainMessageText") then node.MessageBubble.MainMessageText.Text=new_text.."\n<font color='#888888' size='10'><i>(edited)</i></font>" end end
end

-- ====================================================================
--  🔥 FIREBASE POLLING LOOP (Server chat only – no announcements)
-- ====================================================================
local lastFirebaseKey = ""
local firebaseInitialFetch = false

task.spawn(function()
    while task.wait(1.5) do
        if FIREBASE_URL == "https://YOUR-PROJECT-ID-default-rtdb.firebaseio.com/" then
            continue
        end
        local response = makeHttpRequest({
            Url = FIREBASE_URL .. FIREBASE_SERVER_PATH .. "?orderBy=\"$key\"&limitToLast=15",
            Method = "GET"
        })
        if response and response.StatusCode == 200 then
            local ok, data = pcall(function() return HttpService:JSONDecode(response.Body) end)
            if ok and type(data) == "table" then
                local sortedPackets = {}
                for key, packet in pairs(data) do
                    table.insert(sortedPackets, {key = key, val = packet})
                end
                table.sort(sortedPackets, function(a, b) return a.key < b.key end)

                for _, entry in ipairs(sortedPackets) do
                    if entry.key > lastFirebaseKey then
                        lastFirebaseKey = entry.key
                        if firebaseInitialFetch and entry.val.sender ~= LocalPlayer.Name then
                            local sender = entry.val.sender
                            local text = entry.val.text
                            local isImg = entry.val.isImg or false
                            local imgUrl = entry.val.imgUrl or ""
                            local timestamp = entry.val.timestamp or os.time()
                            local msgID = "FIREBASE_" .. entry.key

                            -- Check for Admin Join banner (ARIA says it in chat)
                            if entry.val.isAdminJoin and entry.val.isSystem then
                                -- Skip if admin already announced for this server
                                if AxerChat.AdminJoinAlreadyDone then
                                    -- already done, skip
                                else
                                    -- Add to chat cache so it persists
                                    table.insert(AxerChat.Cache.Server, {Sender = "ARIA", UserID = 0, Msg = text, Time = timestamp, ID = msgID, Edited = false})
                                    -- Trim cache
                                    if #AxerChat.Cache.Server > 100 then
                                        table.remove(AxerChat.Cache.Server, 1)
                                    end
                                    if AxerChat.Mode == "Server" and AxerChat.UI.MainBg and AxerChat.UI.MainBg.Visible then
                                        AxerChat.RenderBubble("ARIA", 0, text, timestamp, msgID, false)
                                    end
                                end
                            elseif entry.val.isSystem then
                                -- Other system messages (skipped)
                            else
                                local userId = 0
                                local p = Players:FindFirstChild(sender)
                                if p then userId = p.UserId end
                                table.insert(AxerChat.Cache.Server, {Sender = sender, UserID = userId, Msg = text, Time = timestamp, ID = msgID, Edited = false})
                                -- Trim cache
                                if #AxerChat.Cache.Server > 100 then
                                    table.remove(AxerChat.Cache.Server, 1)
                                end
                                if AxerChat.Mode == "Server" and AxerChat.UI.MainBg and AxerChat.UI.MainBg.Visible then
                                    AxerChat.RenderBubble(sender, userId, text, timestamp, msgID, false)
                                else
                                    AxerChat.TriggerToast("🌐 Server Chat", sender .. ": " .. text, false, nil, sender)
                                end
                            end
                        end
                    end
                end
                firebaseInitialFetch = true
            end
        end
    end
end)

-- ====================================================================
--  PROXY POLLING (DMs & Admin only)
-- ====================================================================
function AxerChat.StartPolling()
	task.spawn(function()
		local myLower = LocalPlayer.Name:lower(); local snapDM = SafeGet("DMs/" .. myLower)
		if typeof(snapDM) == "table" then
			for pl, msgs in pairs(snapDM) do
				if typeof(msgs) == "table" then
					AxerChat.Cache.DMs[pl] = AxerChat.Cache.DMs[pl] or {}; local dmKey = getDMKey(myLower, pl); local preDM = {}
					for m_id, p in pairs(msgs) do
						if m_id ~= "_typ" and typeof(p) == "table" and tonumber(p.t) then
							if (GetUniverseTimestamp() - tonumber(p.t)) > ONE_WEEK_SECONDS then task.spawn(function() pcall(function() httprequest({Url=STATIC_PROXY.."DMs/"..myLower.."/"..pl.."/"..m_id..".json", Method="DELETE"}) end) end)
							else
								AxerChat.SeenIDs[m_id] = p.sign; if p.s and p.u then AxerChat.RegisterAccount(p.s, nil, p.u) end
								local dec = SecureDecrypt(dmKey, p.m, p.sign); if dec then table.insert(preDM, {Sender = p.s, UserID = p.u, Msg = (dec:sub(1,5) == "[EDT]") and dec:sub(6) or dec, Time = tonumber(p.t), ID = m_id, Edited = (dec:sub(1,5) == "[EDT]")}) end
							end
						end
					end
					table.sort(preDM, function(a, b) return a.Time < b.Time end)
					for _, itm in ipairs(preDM) do table.insert(AxerChat.Cache.DMs[pl], itm) end
				end
			end
		end

		while task.wait(1.5) do
			if getgenv().AxerChat_Unloading then break end
			if not Screen or not Screen.Parent then break end
			local now = GetUniverseTimestamp(); local isGuiVisible = (AxerChat.UI.MainBg and AxerChat.UI.MainBg.Visible)
			local dData = SafeGet("DMs/" .. myLower)
			if dData then
				for pl, msgs in pairs(dData) do
					AxerChat.Cache.DMs[pl] = AxerChat.Cache.DMs[pl] or {}; local dmKey = getDMKey(myLower, pl); local admk = {}
					if not AxerChat.AccountRegistry[pl] then task.spawn(function() local uid = Players:GetUserIdFromNameAsync(pl); local d = pl; if UserService and uid then pcall(function() d = UserService:GetUserInfosByUserIdsAsync({tonumber(uid)})[1].DisplayName end) end; AxerChat.RegisterAccount(pl, d, uid) end) end

					for m_id, pkt in pairs(msgs) do
						admk[m_id] = true; if m_id == "_typ" then continue end
						local pkt_t = tonumber(typeof(pkt)=="table" and pkt.t or 0)
						if now - pkt_t > ONE_WEEK_SECONDS then task.spawn(function() pcall(function() httprequest({Url=STATIC_PROXY.."DMs/"..myLower.."/"..pl.."/"..m_id..".json", Method="DELETE"}); httprequest({Url=STATIC_PROXY.."DMs/"..pl.."/"..myLower.."/"..m_id..".json", Method="DELETE"}) end) end); if AxerChat.ActiveBubbleNodes[m_id] then AxerChat.ActiveBubbleNodes[m_id]:Destroy(); AxerChat.ActiveBubbleNodes[m_id]=nil end continue end

						if typeof(pkt)=="table" and AxerChat.SeenIDs[m_id] ~= pkt.sign and pkt.m and pkt.sign then
							local isK = (AxerChat.SeenIDs[m_id] ~= nil); AxerChat.SeenIDs[m_id] = pkt.sign; if pkt.s and pkt.u then AxerChat.RegisterAccount(pkt.s, nil, pkt.u) end
							local plain = SecureDecrypt(dmKey, pkt.m, pkt.sign)
							if plain then
								local isEdt = (plain:sub(1,5) == "[EDT]"); local trueText = isEdt and plain:sub(6) or plain
								
								local isKeywordMuted = false
								for kw, _ in pairs(AxerChat.MutedKeywords) do if string.find(string.lower(trueText), kw) then isKeywordMuted = true; break end end
								if isKeywordMuted and pkt.s:lower() ~= LocalPlayer.Name:lower() then continue end

								if isK then 
									for _, itm in ipairs(AxerChat.Cache.DMs[pl]) do if itm.ID == m_id then itm.Msg=trueText; itm.Edited=true break end end
									if AxerChat.ActiveBubbleNodes[m_id] and AxerChat.ActiveBubbleNodes[m_id]:FindFirstChild("MessageBubble") then AxerChat.ActiveBubbleNodes[m_id].MessageBubble:SetAttribute("LiveText", trueText); if AxerChat.ActiveBubbleNodes[m_id].MessageBubble:FindFirstChild("MainMessageText") then AxerChat.ActiveBubbleNodes[m_id].MessageBubble.MainMessageText.Text=trueText.."\n<font color='#888888' size='10'><i>(edited)</i></font>" end end
								else
									table.insert(AxerChat.Cache.DMs[pl], {Sender=pkt.s, UserID=pkt.u, Msg=trueText, Time=pkt_t, ID=m_id, Edited=isEdt})
									if isGuiVisible and AxerChat.Mode=="DM" and AxerChat.ActiveDM==pl then AxerChat.RenderBubble(pkt.s, pkt.u, trueText, pkt_t, m_id, isEdt); AxerChat.SetLastRead(pl, GetUniverseTimestamp())
									else AxerChat.TriggerToast("💬 DM : "..AxerChat.GetAccount(pl).DisplayName, trueText, true, pl, pkt.s) end
								end
							end
						end
					end
					if AxerChat.Mode == "DM" and AxerChat.ActiveDM == pl then for aid, n in pairs(AxerChat.ActiveBubbleNodes) do if not admk[aid] and aid~="_typ" then if not (AxerChat.PendingCommitGrace[aid] and os.clock()-AxerChat.PendingCommitGrace[aid]<45) then n:Destroy(); AxerChat.ActiveBubbleNodes[aid]=nil end elseif admk[aid] then AxerChat.PendingCommitGrace[aid]=nil end end end
				end
			end
			AxerChat.LiveUpdateInboxSort(); VerifyMetatableIntegrity()
		end
	end)
end

function AxerChat.UpdateThemeAnimated()
	local t = Themes[ThemeSequence[currentThemeIndex]]; local twInfo = TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	TweenService:Create(AxerChat.UI.MainBg, twInfo, {BackgroundColor3=t.MainBg, BackgroundTransparency=t.BgTrans}):Play(); TweenService:Create(AxerChat.UI.MainStroke, twInfo, {Color=t.StrokeColor}):Play(); TweenService:Create(AxerChat.UI.HeaderBg, twInfo, {BackgroundColor3=t.HeaderBg, BackgroundTransparency=t.HeadTrans}):Play(); TweenService:Create(AxerChat.UI.InputWrapper, twInfo, {BackgroundColor3=t.InputBg, BackgroundTransparency=t.InpTrans}):Play(); TweenService:Create(AxerChat.UI.SearchWrapper, twInfo, {BackgroundColor3=t.InputBg, BackgroundTransparency=t.InpTrans}):Play(); TweenService:Create(AxerChat.UI.ReplyPreview, twInfo, {BackgroundColor3=t.InputBg, BackgroundTransparency=t.InpTrans}):Play(); TweenService:Create(AxerChat.UI.StickerTray, twInfo, {BackgroundColor3=t.HeaderBg}):Play(); TweenService:Create(AxerChat.UI.ImageTray, twInfo, {BackgroundColor3=Color3.fromRGB(16,16,16)}):Play(); TweenService:Create(AxerChat.UI.ImageTray.TopBar.UrlBox, twInfo, {BackgroundColor3=t.InputBg}):Play()
	AxerChat.UI.Title.TextColor3=t.TextColor; AxerChat.UI.TextBox.TextColor3=AxerChat.IsLocked and Color3.fromRGB(255,80,80) or t.TextColor; AxerChat.UI.TextBox.PlaceholderColor3=t.SubText; AxerChat.UI.SearchInput.TextColor3=t.TextColor; AxerChat.UI.SearchInput.PlaceholderColor3=t.SubText; AxerChat.UI.ReplyText.TextColor3=t.SubText; AxerChat.UI.CancelRep.TextColor3=t.SubText; AxerChat.UI.ThemeBtn.BackgroundColor3=t.InputBg; AxerChat.UI.InboxBtn.BackgroundColor3=t.InputBg; AxerChat.UI.MuteBtn.BackgroundColor3=t.InputBg; AxerChat.UI.StickerBtn.BackgroundColor3=t.HeaderBg; AxerChat.UI.ImageBtn.BackgroundColor3=t.HeaderBg; AxerChat.UI.SendBtn.BackgroundColor3=AxerChat.IsLocked and Color3.fromRGB(80,20,20) or t.Accent

	if AxerChat.UI.AdminBtn then TweenService:Create(AxerChat.UI.AdminBtn, twInfo, {BackgroundColor3=t.InputBg}):Play() end
	if AxerChat.UI.AdminTray then TweenService:Create(AxerChat.UI.AdminTray, twInfo, {BackgroundColor3=t.HeaderBg}):Play(); TweenService:Create(AxerChat.UI.AdminSearch, twInfo, {BackgroundColor3=t.InputBg, TextColor3=t.TextColor, PlaceholderColor3=t.SubText}):Play() end

	for _, child in pairs(AxerChat.UI.Scroll:GetChildren()) do
		if child:IsA("Frame") and child:FindFirstChild("MessageBubble") then
			local bub = child.MessageBubble
			local isMe = (bub.AnchorPoint.X == 1)
			local bgCol = isMe and t.MyBubble or t.OtherBubble
			local bgTrans = isMe and t.BubMeTrans or t.BubOtherTrans

			if bub:GetAttribute("IsVIPBubble") then
				ApplyVIPStyleToBubble(bub, AxerChat.CurrentTheme)
			else
				TweenService:Create(bub, twInfo, {BackgroundColor3=bgCol, BackgroundTransparency=bgTrans}):Play()
				if bub:FindFirstChild("MainMessageText") then
					bub.MainMessageText.TextColor3 = t.TextColor
				end
				if bub:FindFirstChild("SenderName") and bub.SenderName.Text~="ARIA" then
					bub.SenderName.TextColor3 = t.NameColor
				end
			end
		elseif child.Name:match("^DM_Card_") or child.Name:match("^SearchCard_") then
			if child:FindFirstChild("AxerUnreadBadge") then TweenService:Create(child, twInfo, {BackgroundColor3=t.Accent}):Play() else TweenService:Create(child, twInfo, {BackgroundColor3=t.OtherBubble, BackgroundTransparency=t.BubOtherTrans}):Play() end
			if child:FindFirstChild("CardName") then child.CardName.TextColor3=t.TextColor end; if child:FindFirstChild("Sub") then child.Sub.TextColor3=t.SubText end
		end
	end
	AxerChat.SyncNativeRobloxBubbleSettings(); AxerChat.LiveSyncAllVisibleBubblesTitle() 
end

AxerChat.BuildMasterUI()
AxerChat.StartPolling()

-- [ 👑 ADMIN JOIN BANNER – ARIA says in chat with audio 2 seconds before ]
task.spawn(function()
    -- Show welcome message locally (ARIA)
    local ariaLocalID = "SYS_LOCAL_ARIA_" .. LocalPlayer.UserId
    local wTxt = "Welcome dear " .. LocalPlayer.DisplayName .. "!"
    table.insert(AxerChat.Cache.Server, {Sender="ARIA", UserID=0, Msg=wTxt, Time=os.time(), ID=ariaLocalID, Edited=false})
    if AxerChat.Mode == "Server" and AxerChat.UI.MainBg.Visible then
        AxerChat.RenderBubble("ARIA", 0, wTxt, os.time(), ariaLocalID, false)
    end
    AxerChat.TriggerArrivalToast(LocalPlayer.DisplayName)

    -- If admin and not already announced for this server
    if IsStrictAdmin() and not AxerChat.AdminJoinAlreadyDone then
        -- Play audio first
        PlayAdminJoinAudio()
        -- Wait 2 seconds
        task.wait(2)
        -- Then broadcast the join message (ARIA will say it in chat)
        BroadcastAdminJoin()
        -- Also add to local chat immediately (so admin sees it)
        local joinMsg = "👑 SUPREME LEADER AND CREATOR OF AXER CHAT SIR AXER HAS JOINED 👑"
        table.insert(AxerChat.Cache.Server, {Sender="ARIA", UserID=0, Msg=joinMsg, Time=os.time(), ID="LOCAL_ADMIN_JOIN", Edited=false})
        if AxerChat.Mode == "Server" and AxerChat.UI.MainBg.Visible then
            AxerChat.RenderBubble("ARIA", 0, joinMsg, os.time(), "LOCAL_ADMIN_JOIN", false)
        end
    end

    task.wait(0.5)
    local netArrID = "SYS_NET_ARRIVAL_" .. LocalPlayer.UserId .. "_" .. os.time()
    local arrPayload = HttpService:JSONEncode({ u=LocalPlayer.UserId, s="SYS_ARIA_ARRIVAL", m=LocalPlayer.DisplayName, sign="ARR_SECURE_"..os.time(), t=os.time() })
    httprequest({Url=STATIC_PROXY.."Srv/"..REAL_JOB_ID.."/"..netArrID..".json", Method="PUT", Body=arrPayload})
end)

-- No system join messages (only admin join banner via ARIA)

local function CommitMessage() 
	if AxerChat.IsLocked then return end
	local txt = AxerChat.UI.TextBox.Text
	if txt ~= "" then 
		
		-- [ STRICT 200 CHARACTERS LIMIT ]
		if string.len(txt) > 200 then
			AxerChat.TriggerAriaLocal("⚠️ <b>Limit Exceeded!</b>\nYour message contains over 200 alphabets/characters. Keep it short!")
			return
		end
		
		if string.lower(txt) == string.lower(AxerChat.LastSentMessage) then
			AxerChat.TriggerAriaLocal("⚠️ <b>Spam Alert!</b>\nYou cannot send the exact same message repeatedly.")
			return
		end
		
		local nowTime = os.clock()
		local recent = {}
		for _, t in ipairs(AxerChat.MessageTimestamps) do
			if nowTime - t <= 3.0 then table.insert(recent, t) end
		end
		AxerChat.MessageTimestamps = recent
		if #AxerChat.MessageTimestamps >= 5 then
			AxerChat.TriggerAriaLocal("⚠️ <b>Spam Blocked!</b>\nYou are typing too fast! (Limit: 5 messages per 3 seconds)")
			return
		end

		AxerChat.UI.TextBox.Text = ""
		AxerChat.LastSentMessage = txt
		table.insert(AxerChat.MessageTimestamps, os.clock())

		-- [ 🔥 /ANNOUNCE REMOVED – no longer available ]

		local vipTarget = txt:match("^/vip%s+(.+)$"); local unvipTarget = txt:match("^/unvip%s+(.+)$"); local titleUser, titleText = txt:match("^/title%s+(@?%S+)%s+(.+)$"); local untitleUser = txt:match("^/untitle%s+(@?%S+)$")
		if vipTarget or unvipTarget or titleUser or untitleUser then
			AxerChat.CancelActionBar()
			if IsStrictAdmin() then
				local cmdStr = titleUser and ("GRANT_TITLE:"..titleUser:gsub("^@",""):lower()..":"..titleText) or (untitleUser and ("REVOKE_TITLE:"..untitleUser:gsub("^@",""):lower()) or (vipTarget and ("GRANT_VIP:"..vipTarget) or ("REVOKE_VIP:"..unvipTarget)))
				local ciphCmd, signCmd = SecureEncrypt("AXER_DEV_ABSOLUTE_ADMIN_WALL_777x0", cmdStr)
				httprequest({Url=STATIC_PROXY.."Srv/"..REAL_JOB_ID.."/SYS_NET_ADM_"..os.time().."_"..math.random(1000,9999)..".json", Method="PUT", Body=HttpService:JSONEncode({ u=LocalPlayer.UserId, s="SYS_ARIA_ADMIN", m=ciphCmd, sign=signCmd, t=GetUniverseTimestamp() })})
			else TitanGuardKick("ADM-SPOOF", "Admin Protocol Breach") end
			return
		end
		if txt:lower():match("^/helpphoto") then
			AxerChat.CancelActionBar(); task.spawn(function()
				local man = "📸 <b>ARIA Media Guide:</b>\n\n1. Copy any image link.\n2. Click the <b>🖼️ Image Button</b>.\n3. Paste link and click <b>Save</b>.\n4. Tap saved tile to broadcast!"
				local hid = "SYS_LOCAL_MANUAL_" .. os.time(); table.insert(AxerChat.Cache.Server, {Sender="ARIA", UserID=0, Msg=man, Time=os.time(), ID=hid, Edited=false})
				if AxerChat.Mode == "Server" and AxerChat.UI.MainBg.Visible then AxerChat.RenderBubble("ARIA", 0, man, os.time(), hid, false) end
			end)
			return
		end
		if AxerChat.EditingMsgID then local tid=AxerChat.EditingMsgID; AxerChat.CancelActionBar(); AxerChat.SubmitEdit(tid, txt)
		else AxerChat.Send(txt); AxerChat.CancelActionBar() end
	end 
end
AxerChat.UI.SendBtn.MouseButton1Click:Connect(CommitMessage)
AxerChat.UI.TextBox.FocusLost:Connect(function(enter) if enter then CommitMessage() end end)
AxerChat.UI.CancelRep.MouseButton1Click:Connect(AxerChat.CancelActionBar)

local searchThread = nil
AxerChat.UI.SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
	if AxerChat.Mode ~= "DM_Inbox" then return end
	local q = AxerChat.UI.SearchInput.Text:match("^%s*(.-)%s*$")
	for _, c in pairs(AxerChat.UI.Scroll:GetChildren()) do if c:IsA("Frame") or c:IsA("TextButton") then c:Destroy() end end
	if not q or #q < 1 then AxerChat.LiveUpdateInboxSort() return end

	local st = Instance.new("TextLabel", AxerChat.UI.Scroll); st.Size=UDim2.new(1,0,0,35); st.BackgroundTransparency=1; st.Font=Enum.Font.GothamMedium; st.TextSize=11; st.TextColor3=Themes[AxerChat.CurrentTheme].SubText; st.Text="Searching network for '"..q.."'..."
	if searchThread then task.cancel(searchThread) end
	searchThread = task.spawn(function()
		task.wait(0.25); local cnt = 0; local seen = {}
		for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and (p.Name:lower():find(q:lower()) or p.DisplayName:lower():find(q:lower())) then seen[p.Name:lower()]=true; cnt=cnt+1; AxerChat.RegisterAccount(p.Name, p.DisplayName, p.UserId); AxerChat.RenderUserSearchCard(p.DisplayName, p.Name, p.UserId) end end
		if #q >= 3 then
			local s, fId = pcall(function() return Players:GetUserIdFromNameAsync(q) end)
			if s and fId then
				local u, dn = q, q
				if UserService then pcall(function() local inf=UserService:GetUserInfosByUserIdsAsync({fId}); u=inf[1].Username or q; dn=inf[1].DisplayName or u end) else pcall(function() u=Players:GetNameFromUserIdAsync(fId); dn=u end) end
				if u ~= LocalPlayer.Name and not seen[u:lower()] then cnt=cnt+1; AxerChat.RegisterAccount(u, dn, fId); AxerChat.RenderUserSearchCard(dn, u, fId) end
			end
		end
		if st and st.Parent then st:Destroy() end
		if cnt == 0 then local n=Instance.new("TextLabel", AxerChat.UI.Scroll); n.Size=UDim2.new(1,0,0,40); n.BackgroundTransparency=1; n.Font=Enum.Font.GothamMedium; n.TextSize=12; n.TextColor3=Color3.fromRGB(210,70,70); n.Text="No users found matching '"..q"'" end
	end)
end)

AxerChat.UI.Back.MouseButton1Click:Connect(function() if AxerChat.Mode=="DM" then AxerChat.SwitchMode("DM_Inbox") elseif AxerChat.Mode=="DM_Inbox" then AxerChat.SwitchMode("Server") end end)
AxerChat.UI.InboxBtn.MouseButton1Click:Connect(function() AxerChat.SwitchMode("DM_Inbox") end)
AxerChat.UI.MuteBtn.MouseButton1Click:Connect(function() AxerChat.MuteServerToasts = not AxerChat.MuteServerToasts; AxerChat.UI.MuteBtn.Text = AxerChat.MuteServerToasts and "🔕" or "🔊"; AxerChat.TriggerToast("🔕 Alerts", AxerChat.MuteServerToasts and "Popups Muted" or "Popups Active", false) end)
AxerChat.UI.ThemeBtn.MouseButton1Click:Connect(function() currentThemeIndex = (currentThemeIndex % 3) + 1; AxerChat.CurrentTheme = ThemeSequence[currentThemeIndex]; AxerChat.UI.ThemeBtn.Text = ThemeIcons[AxerChat.CurrentTheme]; AxerChat.UpdateThemeAnimated() end)