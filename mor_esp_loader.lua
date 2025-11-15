-- // ROBLOX ESP + MOR BEAM (v3.1) – R6 & R15 NOKTA UYUMLULUĞU \\
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local enabled = true
local beamEnabled = true
local objects = {}

-- RENKLER - HEPSİ MOR OLARAK AYARLANDI
local boxColor = Color3.fromRGB(150, 0, 255)   -- MOR (köşeler, tam kutu)
local beamColor = Color3.fromRGB(150, 0, 255)    -- MOR (beam)
local dotColor = Color3.fromRGB(150, 0, 255)   -- MOR (noktalar)

-- R6 VE R15 İÇİN PARÇA LİSTELERİ
-- R6'da sadece 'Torso', 'Arm' ve 'Leg' kullanılır.
local R6_PARTS = {
    "Head",
    "Torso",
    "Left Arm",
    "Right Arm",
    "Left Leg",
    "Right Leg"
}

-- R15'te daha fazla parça ve 'Hand'/'Foot' kullanılır.
local R15_PARTS = {
    "Head",
    "UpperTorso",
    "LeftHand",
    "RightHand",
    "LeftFoot",
    "RightFoot"
}

-- GUI KODLARI BURADA AYNI KALMIŞTIR...
-- GUI
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Ana ESP Butonu
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 90, 0, 44)
mainFrame.Position = UDim2.new(0, 12, 0.5, -22)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 22)

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = Color3.fromRGB(100, 100, 100)
mainStroke.Thickness = 1.5

local mainBtn = Instance.new("TextButton")
mainBtn.Size = UDim2.new(1, -8, 1, -8)
mainBtn.Position = UDim2.new(0, 4, 0, 4)
mainBtn.BackgroundColor3 = enabled and Color3.fromRGB(0, 220, 0) or Color3.fromRGB(220, 0, 0)
mainBtn.Text = enabled and "ESP AÇIK" or "ESP KAPALI"
mainBtn.TextColor3 = Color3.new(1, 1, 1)
mainBtn.TextSize = 14
mainBtn.Font = Enum.Font.GothamBold
mainBtn.Parent = mainFrame
Instance.new("UICorner", mainBtn).CornerRadius = UDim.new(0, 18)

-- MOR Beam Butonu
local beamFrame = Instance.new("Frame")
beamFrame.Size = UDim2.new(0, 90, 0, 44)
beamFrame.Position = UDim2.new(0, 12, 0.5, 30)
beamFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
beamFrame.BorderSizePixel = 0
beamFrame.Parent = gui
Instance.new("UICorner", beamFrame).CornerRadius = UDim.new(0, 22)

local beamStroke = Instance.new("UIStroke", beamFrame)
beamStroke.Color = Color3.fromRGB(100, 100, 100)
beamStroke.Thickness = 1.5

local beamBtn = Instance.new("TextButton")
beamBtn.Size = UDim2.new(1, -8, 1, -8)
beamBtn.Position = UDim2.new(0, 4, 0, 4)
beamBtn.BackgroundColor3 = beamEnabled and Color3.fromRGB(150, 0, 255) or Color3.fromRGB(150, 150, 150)
beamBtn.Text = beamEnabled and "BEAM AÇIK" or "BEAM KAPALI"
beamBtn.TextColor3 = Color3.new(1, 1, 1)
beamBtn.TextSize = 14
beamBtn.Font = Enum.Font.GothamBold
beamBtn.Parent = beamFrame
Instance.new("UICorner", beamBtn).CornerRadius = UDim.new(0, 18)

-- BUTONLAR
mainBtn.MouseButton1Click:Connect(function()
    enabled = not enabled
    mainBtn.Text = enabled and "ESP AÇIK" or "ESP KAPALI"
    mainBtn.BackgroundColor3 = enabled and Color3.fromRGB(0, 220, 0) or Color3.fromRGB(220, 0, 0)
end)

beamBtn.MouseButton1Click:Connect(function()
    beamEnabled = not beamEnabled
    beamBtn.Text = beamEnabled and "BEAM AÇIK" or "BEAM KAPALI"
    beamBtn.BackgroundColor3 = beamEnabled and Color3.fromRGB(150, 0, 255) or Color3.fromRGB(150, 150, 150)
end)

-- ESP EKLEME
local function add(p)
    if p == LocalPlayer or objects[p] then return end
    if not p or not p:IsA("Player") then return end

    local corners = {}
    for i = 1, 8 do
        local line = Drawing.new("Line")
        line.Thickness = 3
        line.Color = boxColor
        line.Transparency = 1
        corners[i] = line
    end

    local fullBox = {}
    for i = 1, 4 do
        local line = Drawing.new("Line")
        line.Thickness = 1.5
        line.Color = boxColor
        line.Transparency = 1
        fullBox[i] = line
    end

    local beam = Drawing.new("Line")
    beam.Thickness = 3
    beam.Color = beamColor
    beam.Transparency = 1
    beam.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)

    local text = Drawing.new("Text")
    text.Size = 12
    text.Center = true
    text.Outline = true
    text.Color = Color3.new(1, 1, 1)
    text.Font = 2

    local dots = {}
    -- Hem R6 hem de R15'in en fazla 6 ana uzvu olduğu için 6 nokta oluşturuyoruz.
    for i = 1, 6 do 
        local dot = Drawing.new("Circle")
        dot.Radius = 4
        dot.Color = dotColor
        dot.Filled = true
        dot.Transparency = 0.4
        dot.Thickness = 2
        dots[i] = dot
    end

    objects[p] = {corners = corners, fullBox = fullBox, beam = beam, text = text, dots = dots}
end

-- KALDIRMA VE DİĞER FONKSİYONLAR AYNI...
local function remove(p)
    if objects[p] then
        for _, v in pairs(objects[p].corners or {}) do if v and v.Remove then v:Remove() end end
        for _, v in pairs(objects[p].fullBox or {}) do if v and v.Remove then v:Remove() end end
        if objects[p].beam and objects[p].beam.Remove then objects[p].beam:Remove() end
        if objects[p].text and objects[p].text.Remove then objects[p].text:Remove() end
        for _, v in pairs(objects[p].dots or {}) do if v and v.Remove then v:Remove() end end
        objects[p] = nil
    end
end

local function cleanup()
    for p, _ in pairs(objects) do
        if not p:IsDescendantOf(Players) then remove(p) end
    end
end

local function getBodyPartPosition(c, partName)
    local part = c:FindFirstChild(partName)
    if part then
        local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
        if onScreen then return Vector2.new(pos.X, pos.Y) end
    end
    return nil
end

-- ANA DÖNGÜ – R6 ve R15 Parça Kontrolü Eklendi
RunService.RenderStepped:Connect(function()
    local localChar = LocalPlayer.Character
    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")

    for p, v in pairs(objects) do
        local c = p.Character
        local root = c and c:FindFirstChild("HumanoidRootPart")
        local head = c and c:FindFirstChild("Head")
        local humanoid = c and c:FindFirstChild("Humanoid")

        -- BEAM VE ESP KAPALI KONTROLLERİ AYNI...
        -- MOR BEAM ÇİZDİR
        if beamEnabled and root and localRoot then
            local rp, onScreen = Camera:WorldToViewportPoint(root.Position)
            v.beam.Visible = onScreen
            if onScreen then
                v.beam.To = Vector2.new(rp.X, rp.Y)
                v.beam.Color = beamColor
            end
        else
            v.beam.Visible = false
        end

        if not enabled then
            for _, line in pairs(v.corners or {}) do line.Visible = false end
            for _, line in pairs(v.fullBox or {}) do line.Visible = false end
            if v.text then v.text.Visible = false end
            for _, dot in pairs(v.dots or {}) do dot.Visible = false end
            continue
        end

        if not c or not root or not head or not humanoid or humanoid.Health <= 0 then
            for _, line in pairs(v.corners or {}) do line.Visible = false end
            for _, line in pairs(v.fullBox or {}) do line.Visible = false end
            if v.text then v.text.Visible = false end
            for _, dot in pairs(v.dots or {}) do dot.Visible = false end
            continue
        end

        local rp, on = Camera:WorldToViewportPoint(root.Position)
        local hp = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
        local lp = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3.5, 0))

        if on then
            -- ... KUTU VE YAZI ÇİZİMİ KODLARI AYNI ...
            local dist = math.floor((localRoot.Position - root.Position).Magnitude / 5)
            local health = math.floor(humanoid.Health)
            local max = humanoid.MaxHealth

            v.text.Text = p.DisplayName .. " [" .. health .. "/" .. max .. "] " .. dist .. "m"
            v.text.Position = Vector2.new(rp.X, hp.Y - 25)
            v.text.Visible = true

            local h = math.abs(hp.Y - lp.Y) * 1.1
            local w = h * 0.65
            local cornerLength = math.min(w, h) * 0.2

            local boxTopLeft = Vector2.new(rp.X - w / 2, hp.Y)
            local boxTopRight = Vector2.new(rp.X + w / 2, hp.Y)
            local boxBottomLeft = Vector2.new(rp.X - w / 2, hp.Y + h)
            local boxBottomRight = Vector2.new(rp.X + w / 2, hp.Y + h)

            -- TAM KUTU ÇİZGİLERİ
            v.fullBox[1].From = boxTopLeft
            v.fullBox[1].To = boxTopRight
            v.fullBox[2].From = boxTopRight
            v.fullBox[2].To = boxBottomRight
            v.fullBox[3].From = boxBottomRight
            v.fullBox[3].To = boxBottomLeft
            v.fullBox[4].From = boxBottomLeft
            v.fullBox[4].To = boxTopLeft
            for _, line in pairs(v.fullBox) do line.Visible = true end

            -- KÖŞELER
            v.corners[1].From = boxTopLeft
            v.corners[1].To = Vector2.new(boxTopLeft.X + cornerLength, boxTopLeft.Y)
            v.corners[2].From = boxTopLeft
            v.corners[2].To = Vector2.new(boxTopLeft.X, boxTopLeft.Y + cornerLength)
            v.corners[3].From = boxTopRight
            v.corners[3].To = Vector2.new(boxTopRight.X - cornerLength, boxTopRight.Y)
            v.corners[4].From = boxTopRight
            v.corners[4].To = Vector2.new(boxTopRight.X, boxTopRight.Y + cornerLength)
            v.corners[5].From = boxBottomLeft
            v.corners[5].To = Vector2.new(boxBottomLeft.X + cornerLength, boxBottomLeft.Y)
            v.corners[6].From = boxBottomLeft
            v.corners[6].To = Vector2.new(boxBottomLeft.X, boxBottomLeft.Y - cornerLength)
            v.corners[7].From = boxBottomRight
            v.corners[7].To = Vector2.new(boxBottomRight.X - cornerLength, boxBottomRight.Y)
            v.corners[8].From = boxBottomRight
            v.corners[8].To = Vector2.new(boxBottomRight.X, boxBottomRight.Y - cornerLength)
            for _, line in pairs(v.corners) do line.Visible = true end

            -- NOKTALAR - R6 VEYA R15'İ KONTROL ET
            local isR6 = c:FindFirstChild("Torso") and not c:FindFirstChild("UpperTorso")
            local partsToUse = isR6 and R6_PARTS or R15_PARTS
            
            for i, partName in ipairs(partsToUse) do
                local pos = getBodyPartPosition(c, partName)
                if pos and v.dots[i] then
                    v.dots[i].Position = pos
                    v.dots[i].Visible = true
                elseif v.dots[i] then
                    v.dots[i].Visible = false
                end
            end
        else
            -- EKRAN DIŞINDAYSA GİZLE
            for _, line in pairs(v.corners or {}) do line.Visible = false end
            for _, line in pairs(v.fullBox or {}) do line.Visible = false end
            if v.text then v.text.Visible = false end
            for _, dot in pairs(v.dots or {}) do dot.Visible = false end
        end
    end
end)

-- ... DİĞER BAĞLANTILAR AYNI ...

-- TEMİZLEME
local cleanupConnection = RunService.Heartbeat:Connect(cleanup)

-- OYUNCU EKLEME
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(0.7)
        add(p)
    end)
end)

Players.PlayerRemoving:Connect(remove)

for _, p in Players:GetPlayers() do
    if p ~= LocalPlayer then
        if p.Character then add(p) end
        p.CharacterAdded:Connect(function()
            task.wait(0.7)
            add(p)
        end)
    end
end

-- TEMİZ ÇIKIŞ
gui.Destroying:Connect(function()
    if cleanupConnection then cleanupConnection:Disconnect() end
    for p in pairs(objects) do remove(p) end
end)
