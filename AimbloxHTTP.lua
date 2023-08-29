--Aimblox script made by YoinkedYoink#4488
--My github for more scripts: https://github.com/YoinkedYoink/Roblox-Scripts

--THIS IS THE HTTP VERSION
--USE THE HTTP SERVER PYTHON SCRIPT

    getgenv().ServerAddress = "127.0.0.1:6969"

--(Coming soon maybe)Visit http://127.0.0.1:6969/Home/ to change settings (or the changes server address)
--Or change the settings.xml file


local RunService = game:GetService("RunService")
local CurCamV = game:GetService("Workspace").CurrentCamera.ViewportSize
local Workspace = game:GetService("Workspace")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

function ServerReconnect()
    CheckText = Drawing.new("Text")
    CheckText.Text = "Checking if server is online..."
    CheckText.Size = 50 * (CurCamV.X/1920)
    CheckText.Color = Color3.new(255,17,130)
    CheckText.Center = true
    CheckText.Outline = true
    CheckText.OutlineColor = Color3.fromRGB(190,10,70)
    CheckText.Position = Vector2.new(CurCamV.X/2,CurCamV.Y/5)
    CheckText.ZIndex = -999

    function ConHTTP()
        SendData = request({Url = "http://"..getgenv().ServerAddress.."/status/", Method = "GET"})
        if SendData.StatusCode == 200 then
            CurCamV = game:GetService("Workspace").CurrentCamera.ViewportSize
            CheckText:Remove()
            CheckText = Drawing.new("Text")
            CheckText.Text = "Server is online!"
            CheckText.Size = 50 * (CurCamV.X/1920)
            CheckText.Color = Color3.new(255,17,130)
            CheckText.Center = true
            CheckText.Outline = true
            CheckText.OutlineColor = Color3.fromRGB(190,10,70)
            CheckText.Position = Vector2.new(CurCamV.X/2,CurCamV.Y/5)
            CheckText.ZIndex = -999
            getgenv().checksettings = true
            wait(5)
            CheckText:Remove()
        else
            print(math.random("h"))
        end
    end

    local ConOrNot = pcall(ConHTTP)
    while not ConOrNot do
        wait(2)
        ConOrNot = pcall(ConHTTP)
    end
end

ServerReconnect()

function SetSettings(Body)
    decodedjson = game:GetService("HttpService"):JSONDecode(Body)
    
    getgenv().aimbotfov = decodedjson.aimbot.fov
    getgenv().aimbothitpart = decodedjson.aimbot.hitpart
    getgenv().aimbotfovcircle = decodedjson.aimbot.fovcircle
    getgenv().aimbotsnapline = decodedjson.aimbot.snapline
    getgenv().aimbotautoshoot = decodedjson.aimbot.autoshoot
    getgenv().aimbotsensitivity = decodedjson.aimbot.sensitivity
    getgenv().aimbotkeybind = decodedjson.aimbot.keybind

    getgenv().visualsesp = decodedjson.visuals.esp
    
    getgenv().movementspeed = decodedjson.movement.speed
    getgenv().movementspeedvalue = decodedjson.movement.speedvalue
    getgenv().movementflyvalue = decodedjson.movement.flyvalue
    getgenv().movementflykeybind = decodedjson.movement.flykeybind

    getgenv().ragespinbot = decodedjson.rage.spinbot
    getgenv().ragespinspeed = decodedjson.rage.spinspeed

    if getgenv().FOVC ~= nil then
        getgenv().FOVC.Radius = (math.abs(getgenv().aimbotfov/((game:GetService("Workspace").CurrentCamera.FieldOfView*(CurCamV.X/CurCamV.Y))/CurCamV.X)))/2
        getgenv().FOVC.Visible = getgenv().aimbotfovcircle
    end

end

GetSettings = request({Url = "http://"..getgenv().ServerAddress.."/getsettings/", Method = "GET"})
if GetSettings.StatusCode == 200 then
	getgenv().SettingsHash = tostring(GetSettings.Headers["MD5-Hash"])
    SettingsBody = GetSettings.Body
    SetSettings(SettingsBody)

    CurCamV = game:GetService("Workspace").CurrentCamera.ViewportSize
    SettingsText = Drawing.new("Text")
    SettingsText.Text = "Loaded xinex!"
    SettingsText.Size = 50 * (CurCamV.X/1920)
    SettingsText.Color = Color3.new(255,17,130)
    SettingsText.Center = true
    SettingsText.Outline = true
    SettingsText.OutlineColor = Color3.fromRGB(190,10,70)
    SettingsText.Position = Vector2.new(CurCamV.X/2,CurCamV.Y/5)
    SettingsText.ZIndex = -999
    wait(3)
    SettingsText:Remove()
end

function SettingsCheck()
    while true do
        wait(5)
        if getgenv().checksettings then
            GetSettings = request({Url = "http://"..getgenv().ServerAddress.."/getsettings/#"..math.random(1,65565), Method = "GET"})
            if GetSettings.StatusCode == 200 then
                if tostring(GetSettings.Headers["MD5-Hash"]) ~= getgenv().SettingsHash then
                    getgenv().SettingsHash = tostring(GetSettings.Headers["MD5-Hash"])
                    SettingsBody = GetSettings.Body
                    SetSettings(SettingsBody)

                    CurCamV = game:GetService("Workspace").CurrentCamera.ViewportSize
                    SettingsText = Drawing.new("Text")
                    SettingsText.Text = "Changed Settings!"
                    SettingsText.Size = 50 * (CurCamV.X/1920)
                    SettingsText.Color = Color3.new(255,17,130)
                    SettingsText.Center = true
                    SettingsText.Outline = true
                    SettingsText.OutlineColor = Color3.fromRGB(190,10,70)
                    SettingsText.Position = Vector2.new(CurCamV.X/2,CurCamV.Y/5)
                    SettingsText.ZIndex = -999
                    wait(3)
                    SettingsText:Remove()
                end
            else
                getgenv().checksettings = false
                ServerReconnect()
            end
        end
    end
end

SettingsCheckCoroutine = coroutine.create(SettingsCheck)
SettingsCheckStart = coroutine.resume(SettingsCheckCoroutine)

function findplraimbot()
    local CurCamV = game:GetService("Workspace").CurrentCamera.ViewportSize
    local Workspace = game:GetService("Workspace")
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local Players = game:GetService("Players")
        for _,i in next, Players:GetPlayers() do
            BlackTable = {}
            raycwast = nil
            if i.Name ~= LocalPlayer.Name then
                if Workspace:FindFirstChild(i.Name) then
                    RaycastPR = RaycastParams.new()
                    table.insert(BlackTable, LocalPlayer.Character)
                    table.insert(BlackTable, Workspace.CurrentCamera)
                    table.insert(BlackTable, Workspace.Ignore)
                    for u,m in pairs(Workspace:GetChildren()) do
                        if string.match(tostring(m), "PseudoCharacter") then
                            table.insert(BlackTable, m)
                        end
                    end
                    if game:GetService("Workspace").CompetitiveMap:FindFirstChild("fooliage") then
                        if game:GetService("Workspace").CompetitiveMap.fooliage:FindFirstChild("Grass") then
                            table.insert(BlackTable, game:GetService("Workspace").CompetitiveMap.fooliage.Grass)
                        end
                    end
                    if game:GetService("Workspace").CompetitiveMap:FindFirstChild("Presets") then
                        table.insert(BlackTable, game:GetService("Workspace").CompetitiveMap.Presets)
                    end
                    if game:GetService("Workspace").CompetitiveMap:FindFirstChild("Particles") then
                        table.insert(BlackTable, game:GetService("Workspace").CompetitiveMap.Particles)
                    end
                    RaycastPR.FilterDescendantsInstances = BlackTable
                    RaycastPR.FilterType = Enum.RaycastFilterType.Blacklist
                    RaycastPR.RespectCanCollide = false
                    if Workspace[i.Name]:FindFirstChild(getgenv().aimbothitpart) then
                        local ScreenP = Workspace.CurrentCamera:WorldToViewportPoint(Workspace[i.Name][getgenv().aimbothitpart].Position)
                        local cam = math.abs(getgenv().aimbotfov/((Workspace.CurrentCamera.FieldOfView*(CurCamV.X/CurCamV.Y))/CurCamV.X))
                        if (ScreenP and ScreenP.Z > 0) and (Vector2.new(CurCamV.X/2,CurCamV.Y/2) - Vector2.new(ScreenP.X, ScreenP.Y)).Magnitude <= cam/2 then
                            if LocalPlayer.Character:FindFirstChild("Head") then
                                if Workspace[i.Name]:FindFirstChild("Shading") then
                                if Workspace[i.Name].Shading.OutlineTransparency ~= 1 then
                                Diwection = CFrame.lookAt(LocalPlayer.Character.Head.Position, Workspace[i.Name][getgenv().aimbothitpart].Position)
                                raycwast = Workspace:Raycast(LocalPlayer.Character.Head.Position, Diwection.lookVector*2000, RaycastPR)
                                if raycwast ~= nil then
                                    if string.match(tostring(raycwast.Instance:GetFullName()), LocalPlayer.Name) == nil then
                                        if string.match(tostring(raycwast.Instance:GetFullName()), i.Name) ~= nil then
                                            if getgenv().mag ~= nil then
                                                temp = ((Vector2.new(CurCamV.X/2,CurCamV.Y/2)) - (Vector2.new(ScreenP.X,ScreenP.Y))).Magnitude
                                                if getgenv().mag > temp then
                                                    getgenv().mag = temp
                                                    getgenv().hiya = ScreenP
                                                end
                                            else
                                                getgenv().mag = ((Vector2.new(CurCamV.X/2,CurCamV.Y/2)) - (Vector2.new(ScreenP.X,ScreenP.Y))).Magnitude
                                                getgenv().Lookie = Diwection
                                                getgenv().hiya = ScreenP
                                            end
                                        else
                                        end
                                    else
                                    end
                                else
                                end
                                end
                                end
                            end
                        end
                    end
                end
            end
        end
    end


function doaimbotpls()
    while true do
        if getgenv().runaimbot then
            if Workspace:FindFirstChild(LocalPlayer.Name) then
                findplraimbot()
                if getgenv().hiya ~= nil then
                    if getgenv().aimbotsnapline then
                        if getgenv().Sline == nil then
                            getgenv().Sline = Drawing.new("Line")
                        end
                        getgenv().Sline.Visible = true
                        getgenv().Sline.ZIndex = -99999999
                        getgenv().Sline.Transparency = 0.6
                        getgenv().Sline.Color = Color3.fromRGB(0,200,40)
                        getgenv().Sline.Thickness = 2
                        getgenv().Sline.From = Vector2.new(CurCamV.X/2,CurCamV.Y/2)
                        getgenv().Sline.To = Vector2.new(getgenv().hiya.X, getgenv().hiya.Y)
                    elseif getgenv().aimbotsnapline == false and getgenv().Sline ~= nil then
                        getgenv().Sline.Visible = false
                    end
                    SendData = request({Url = tostring("http://"..getgenv().ServerAddress.."/mousemove/"..tostring(((getgenv().hiya.X) - CurCamV.X/2)/getgenv().aimbotsensitivity).."/"..tostring(((getgenv().hiya.Y) - CurCamV.Y/2)/getgenv().aimbotsensitivity).."#"..math.random(1,65565)), Method = "POST"})
                    tmp = SendData.Body
                    getgenv().hiya = nil
                    if getgenv().aimbotautoshoot then
                        if game:GetService("Players").LocalPlayer.PlayerGui.Crosshair.Crosshair.TopFrame.BackgroundColor3 == Color3.fromRGB(255, 0, 0) then
                            pcall(function()
                                SendData = request({Url = tostring("http://"..getgenv().ServerAddress.."/mouseclick/".."#"..math.random(1,655)), Method = "POST"})
                                tmp = SendData.Body
                            end)
                        end
                    end
                elseif getgenv().hiya == nil then
                    if getgenv().Sline ~= nil then
                        getgenv().Sline.Visible = false
                    end
                end
                getgenv().mag = nil
                getgenv().hiya = nil
            end
            task.wait()
        end
        if getgenv().runaimbot == false then
            if getgenv().Sline ~= nil then
                getgenv().Sline.Visible = false
            end
        end
        task.wait()
    end
end

function coaimbot()
    doaimbotpls()
end

function cofly()
    while true do
        while getgenv().runfly do
            local Workspace = game:GetService("Workspace")
            local LocalPlayer = game:GetService("Players").LocalPlayer
            if Workspace:FindFirstChild(LocalPlayer.Name) then
                if LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.CFrame.X,LocalPlayer.Character.HumanoidRootPart.CFrame.Y+getgenv().movementflyvalue,LocalPlayer.Character.HumanoidRootPart.CFrame.Z)
                    LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(LocalPlayer.Character.HumanoidRootPart.Velocity.X,0,LocalPlayer.Character.HumanoidRootPart.Velocity.Z)
                end
            end
            wait()
        end
        wait()
    end
end


flycoroutine = coroutine.create(cofly)
flycoroutinestart = coroutine.resume(flycoroutine)

aimbotcoroutine = coroutine.create(coaimbot)
aimbotcoroutinestart = coroutine.resume(aimbotcoroutine)

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end

    if UserInputService:IsKeyDown(getgenv().aimbotkeybind) then
        getgenv().runaimbot = true
    else
        getgenv().runaimbot = false
    end

    if UserInputService:IsKeyDown(getgenv().movementflykeybind) then
        getgenv().runfly = true
    else
        getgenv().runfly = false
    end

    task.wait()
end)
UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end

    if UserInputService:IsKeyDown(getgenv().aimbotkeybind) then
        getgenv().runaimbot = true
    else
        getgenv().runaimbot = false
    end

    if UserInputService:IsKeyDown(getgenv().movementflykeybind) then
        getgenv().runfly = true
    else
        getgenv().runfly = false
    end

    task.wait()
end)



CurCamV = game:GetService("Workspace").CurrentCamera.ViewportSize
getgenv().FOVC = Drawing.new("Circle")
getgenv().FOVC.Visible = getgenv().aimbotfovcircle
getgenv().FOVC.ZIndex = -9999999
getgenv().FOVC.Transparency = 0.8
getgenv().FOVC.Color = Color3.fromRGB(255,5,239)
getgenv().FOVC.Thickness = 1
getgenv().FOVC.NumSides = 200
getgenv().FOVC.Radius = (math.abs(getgenv().aimbotfov/((game:GetService("Workspace").CurrentCamera.FieldOfView*(CurCamV.X/CurCamV.Y))/CurCamV.X)))/2
getgenv().FOVC.Filled = false
getgenv().FOVC.Position = Vector2.new(CurCamV.X/2,CurCamV.Y/2)

function SizeChange()
    CurCamV = game:GetService("Workspace").CurrentCamera.ViewportSize
    getgenv().FOVC.Radius = (math.abs(getgenv().aimbotfov/((game:GetService("Workspace").CurrentCamera.FieldOfView*(CurCamV.X/CurCamV.Y))/CurCamV.X)))/2
    getgenv().FOVC.Position = Vector2.new(CurCamV.X/2,CurCamV.Y/2)


end

game:GetService("Workspace").CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(SizeChange)

setup = true