-- // ROBLOX ESP + MOR BEAM (v5.2 Optimize Edilmiş Sürüm, İsim Üstte + Can/Mesafe Altta)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local enabled = true
local beamEnabled = true
local objects = {}
local teamCheckEnabled = true

-- RENKLER
local ENEMY_COLOR = Color3.fromRGB(180, 0, 255)
local FRIEND_COLOR = Color3.fromRGB(0, 200, 0)
local BEAM_COLOR = Color3.fromRGB(180, 0, 255)
local WHITE_TEXT_COLOR = Color3.fromRGB(255, 255, 255)

-- R6/R15 PARTS
local R6_PARTS = {"Head","Torso","Left Arm","Right Arm","Left Leg","Right Leg"}
local R15_PARTS = {"Head","UpperTorso","LowerTorso","LeftUpperArm","LeftLowerArm","LeftHand","RightUpperArm","RightLowerArm","RightHand","LeftUpperLeg","LeftLowerLeg","LeftFoot","RightUpperLeg","RightLowerLeg","RightFoot"}

-- SKELETONS
local R6_SKELETON = {{"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},{"Torso","Left Leg"},{"Torso","Right Leg"}}
local R15_SKELETON = {{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"}}

-- GUI
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- ESP Butonu
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 90, 0, 44)
mainFrame.Position = UDim2.new(0, 12, 0.5, -22)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,22)
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = Color3.fromRGB(100,100,100)
mainStroke.Thickness = 1.5
local mainBtn = Instance.new("TextButton")
mainBtn.Size = UDim2.new(1,-8,1,-8)
mainBtn.Position = UDim2.new(0,4,0,4)
mainBtn.BackgroundColor3 = enabled and Color3.fromRGB(0,220,0) or Color3.fromRGB(220,0,0)
mainBtn.Text = enabled and "ESP AÇIK" or "ESP KAPALI"
mainBtn.TextColor3 = Color3.new(1,1,1)
mainBtn.TextSize = 14
mainBtn.Font = Enum.Font.GothamBold
mainBtn.Parent = mainFrame
Instance.new("UICorner", mainBtn).CornerRadius = UDim.new(0,18)
mainBtn.MouseButton1Click:Connect(function()
enabled = not enabled
mainBtn.Text = enabled and "ESP AÇIK" or "ESP KAPALI"
mainBtn.BackgroundColor3 = enabled and Color3.fromRGB(0,220,0) or Color3.fromRGB(220,0,0)
end)

-- Beam Butonu
local beamFrame = Instance.new("Frame")
beamFrame.Size = UDim2.new(0, 90, 0, 44)
beamFrame.Position = UDim2.new(0,12,0.5,30)
beamFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
beamFrame.BorderSizePixel = 0
beamFrame.Parent = gui
Instance.new("UICorner", beamFrame).CornerRadius = UDim.new(0,22)
local beamStroke = Instance.new("UIStroke", beamFrame)
beamStroke.Color = Color3.fromRGB(100,100,100)
beamStroke.Thickness = 1.5
local beamBtn = Instance.new("TextButton")
beamBtn.Size = UDim2.new(1,-8,1,-8)
beamBtn.Position = UDim2.new(0,4,0,4)
beamBtn.BackgroundColor3 = beamEnabled and BEAM_COLOR or Color3.fromRGB(150,150,150)
beamBtn.Text = beamEnabled and "BEAM AÇIK" or "BEAM KAPALI"
beamBtn.TextColor3 = Color3.new(1,1,1)
beamBtn.TextSize = 14
beamBtn.Font = Enum.Font.GothamBold
beamBtn.Parent = beamFrame
Instance.new("UICorner", beamBtn).CornerRadius = UDim.new(0,18)
beamBtn.MouseButton1Click:Connect(function()
beamEnabled = not beamEnabled
beamBtn.Text = beamEnabled and "BEAM AÇIK" or "BEAM KAPALI"
beamBtn.BackgroundColor3 = beamEnabled and BEAM_COLOR or Color3.fromRGB(150,150,150)
end)

-- Add ESP
local function add(p,c)
if p==LocalPlayer or objects[p] then return end
local isR6=c:FindFirstChild("Torso") and not c:FindFirstChild("UpperTorso")
local partsToUse=isR6 and R6_PARTS or R15_PARTS
local skeletonToUse=isR6 and R6_SKELETON or R15_SKELETON
local boxColor=ENEMY_COLOR
local corners, fullBox, dots, skeletons = {}, {}, {}, {}

for i=1,8 do corners[i]=Drawing.new("Line") corners[i].Thickness=3 corners[i].Color=boxColor corners[i].Transparency=1 end  
for i=1,4 do fullBox[i]=Drawing.new("Line") fullBox[i].Thickness=1.5 fullBox[i].Color=boxColor fullBox[i].Transparency=1 end  
local beam=Drawing.new("Line") beam.Thickness=3 beam.Color=BEAM_COLOR beam.Transparency=1  

local nameText=Drawing.new("Text")  
nameText.Size=14 nameText.Center=true nameText.Outline=true nameText.Color=WHITE_TEXT_COLOR nameText.Font=2  
local statusText=Drawing.new("Text") -- Bu, Can ve Mesafeyi gösterecek  
statusText.Size=12 statusText.Center=true statusText.Outline=true statusText.Color=WHITE_TEXT_COLOR statusText.Font=2  

local healthBarOutline=Drawing.new("Line") -- Can Barı Ana Hat  
healthBarOutline.Thickness=2 healthBarOutline.Color=Color3.fromRGB(255,255,255) healthBarOutline.Transparency=1  
local healthBarFill=Drawing.new("Line") -- Can Barı Dolgusu  
healthBarFill.Thickness=2 healthBarFill.Color=Color3.fromRGB(0,255,0) healthBarFill.Transparency=1  

local maxParts=math.max(#R6_PARTS,#R15_PARTS)  
for i=1,maxParts do  
    local dot=Drawing.new("Circle")  
    dot.Radius=4 dot.Color=boxColor dot.Filled=true dot.Transparency=0.4 dot.Thickness=2  
    dots[i]=dot  
end  

local maxSkeletonLines=math.max(#R6_SKELETON,#R15_SKELETON)  
for i=1,maxSkeletonLines do  
    local line=Drawing.new("Line")  
    line.Thickness=2 line.Color=boxColor line.Transparency=1 line.Visible=false  
    skeletons[i]=line  
end  

objects[p]={corners=corners,fullBox=fullBox,beam=beam,nameText=nameText,statusText=statusText,healthBarOutline=healthBarOutline,healthBarFill=healthBarFill,dots=dots,skeletons=skeletons,partsToUse=partsToUse,skeletonToUse=skeletonToUse}

end

local function remove(p)
if objects[p] then
for _,v in pairs(objects[p].corners or {}) do if v and v.Remove then v:Remove() end end
for _,v in pairs(objects[p].fullBox or {}) do if v and v.Remove then v:Remove() end end
if objects[p].beam and objects[p].beam.Remove then objects[p].beam:Remove() end
if objects[p].nameText and objects[p].nameText.Remove then objects[p].nameText:Remove() end
if objects[p].statusText and objects[p].statusText.Remove then objects[p].statusText:Remove() end
if objects[p].healthBarOutline and objects[p].healthBarOutline.Remove then objects[p].healthBarOutline:Remove() end
if objects[p].healthBarFill and objects[p].healthBarFill.Remove then objects[p].healthBarFill:Remove() end
for _,v in pairs(objects[p].dots or {}) do if v and v.Remove then v:Remove() end end
for _,v in pairs(objects[p].skeletons or {}) do if v and v.Remove then v:Remove() end end
objects[p]=nil
end
end

local function cleanup()
for p,_ in pairs(objects) do if not Players:FindFirstChild(p.Name) then remove(p) end end
end

local function getBodyPartPosition(c,partName)
local part=c:FindFirstChild(partName)
if part then
local pos,onScreen=Camera:WorldToViewportPoint(part.Position)
if onScreen then return Vector2.new(pos.X,pos.Y) end
end
return nil
end

RunService.RenderStepped:Connect(function()
local localChar=LocalPlayer.Character
local localRoot=localChar and localChar:FindFirstChild("HumanoidRootPart")
local cameraCenterBottom=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y)
for p,v in pairs(objects) do
local c=p.Character
local root=c and c:FindFirstChild("HumanoidRootPart")
local head=c and c:FindFirstChild("Head")
local humanoid=c and c:FindFirstChild("Humanoid")
local isFriendly=false
if teamCheckEnabled and LocalPlayer.Team and p.Team then if LocalPlayer.Team==p.Team then isFriendly=true end end
local boxDotColor=isFriendly and FRIEND_COLOR or ENEMY_COLOR
local textColor=isFriendly and FRIEND_COLOR or WHITE_TEXT_COLOR

-- Beam  
    if beamEnabled and root and localRoot then  
        local rp,onScreen=Camera:WorldToViewportPoint(root.Position)  
        v.beam.Visible=onScreen  
        if onScreen then  
            v.beam.To=Vector2.new(rp.X,rp.Y)  
            v.beam.From=cameraCenterBottom  
            v.beam.Color=BEAM_COLOR  
        end  
    else v.beam.Visible=false end  

    if not enabled then  
        for _,line in pairs(v.corners or {}) do line.Visible=false end  
        for _,line in pairs(v.fullBox or {}) do line.Visible=false end  
        if v.nameText then v.nameText.Visible=false end  
        if v.statusText then v.statusText.Visible=false end  
        if v.healthBarOutline then v.healthBarOutline.Visible=false end  
        if v.healthBarFill then v.healthBarFill.Visible=false end  
        for _,dot in pairs(v.dots or {}) do dot.Visible=false end  
        for _,line in pairs(v.skeletons or {}) do line.Visible=false end  
        continue  
    end  

    if not c or not root or not head or not humanoid or humanoid.Health<=0 then  
        for _,line in pairs(v.corners or {}) do line.Visible=false end  
        for _,line in pairs(v.fullBox or {}) do line.Visible=false end  
        if v.nameText then v.nameText.Visible=false end  
        if v.statusText then v.statusText.Visible=false end  
        if v.healthBarOutline then v.healthBarOutline.Visible=false end  
        if v.healthBarFill then v.healthBarFill.Visible=false end  
        for _,dot in pairs(v.dots or {}) do dot.Visible=false end  
        for _,line in pairs(v.skeletons or {}) do line.Visible=false end  
        continue  
    end  

    local rp,on=Camera:WorldToViewportPoint(root.Position)  
    local hp=Camera:WorldToViewportPoint(head.Position+Vector3.new(0,0.5,0))  
    local lp=Camera:WorldToViewportPoint(root.Position-Vector3.new(0,3.5,0))  

    if on then  
        for _,line in pairs(v.corners) do line.Color=boxDotColor end  
        for _,line in pairs(v.fullBox) do line.Color=boxDotColor end  
        for _,line in pairs(v.skeletons) do line.Color=boxDotColor end  
        for _,dot in pairs(v.dots) do dot.Color=boxDotColor end  
        v.nameText.Color=textColor  
        v.statusText.Color=textColor  

        local dist=math.floor((localRoot.Position-root.Position).Magnitude)  
        local health=math.floor(humanoid.Health)  
        local max=humanoid.MaxHealth  
        local healthPercent=math.floor((health/max)*100)  

        -- İsim barı (Kutunun Üstü)
        v.nameText.Text=p.DisplayName  
        v.nameText.Position=Vector2.new(rp.X,hp.Y-15) -- Konumu biraz daha kutuya yaklaştırdım  
        v.nameText.Visible=true  

        local h=math.abs(hp.Y-lp.Y)*1.1  
        local w=h*0.65  
        local cornerLength=math.min(w,h)*0.2  
        local boxTopLeft=Vector2.new(rp.X-w/2,hp.Y)  
        local boxTopRight=Vector2.new(rp.X+w/2,hp.Y)  
        local boxBottomLeft=Vector2.new(rp.X-w/2,hp.Y+h)  
        local boxBottomRight=Vector2.new(rp.X+w/2,hp.Y+h)  

        v.fullBox[1].From=boxTopLeft v.fullBox[1].To=boxTopRight  
        v.fullBox[2].From=boxTopRight v.fullBox[2].To=boxBottomRight  
        v.fullBox[3].From=boxBottomRight v.fullBox[3].To=boxBottomLeft  
        v.fullBox[4].From=boxBottomLeft v.fullBox[4].To=boxTopLeft  
        for _,line in pairs(v.fullBox) do line.Visible=true end  

        v.corners[1].From=boxTopLeft v.corners[1].To=Vector2.new(boxTopLeft.X+cornerLength,boxTopLeft.Y)  
        v.corners[2].From=boxTopLeft v.corners[2].To=Vector2.new(boxTopLeft.X,boxTopLeft.Y+cornerLength)  
        v.corners[3].From=boxTopRight v.corners[3].To=Vector2.new(boxTopRight.X-cornerLength,boxTopRight.Y)  
        v.corners[4].From=boxTopRight v.corners[4].To=Vector2.new(boxTopRight.X,boxTopRight.Y+cornerLength)  
        v.corners[5].From=boxBottomLeft v.corners[5].To=Vector2.new(boxBottomLeft.X+cornerLength,boxBottomLeft.Y)  
        v.corners[6].From=boxBottomLeft v.corners[6].To=Vector2.new(boxBottomLeft.X,boxBottomLeft.Y-cornerLength)  
        v.corners[7].From=boxBottomRight v.corners[7].To=Vector2.new(boxBottomRight.X-cornerLength,boxBottomRight.Y)  
        v.corners[8].From=boxBottomRight v.corners[8].To=Vector2.new(boxBottomRight.X,boxBottomRight.Y-cornerLength)  
        for _,line in pairs(v.corners) do line.Visible=true end  

        -- Can Barı ve Mesafe (Kutunun Altı)
        local healthBarY=boxBottomLeft.Y+4 -- Kutunun altından biraz aşağıya
        local healthBarWidth=w
        local healthBarEnd=boxBottomLeft.X+healthBarWidth
        
        -- Can Barı Ana Hat (Beyaz çizgi)
        v.healthBarOutline.From=Vector2.new(boxBottomLeft.X,healthBarY)
        v.healthBarOutline.To=Vector2.new(healthBarEnd,healthBarY)
        v.healthBarOutline.Visible=true

        -- Can Barı Dolgusu (Sağlık durumuna göre renkli çizgi)
        local healthFillEnd=boxBottomLeft.X+(healthBarWidth*(health/max))
        v.healthBarFill.From=Vector2.new(boxBottomLeft.X,healthBarY)
        v.healthBarFill.To=Vector2.new(healthFillEnd,healthBarY)
        v.healthBarFill.Color=Color3.new(1-(health/max),health/max,0) -- Kırmızıdan Yeşile doğru geçiş
        v.healthBarFill.Visible=true

        -- Mesafe ve Yüzdelik (Can barının biraz altına)
        v.statusText.Text="["..healthPercent.."%] "..dist.."m"  
        v.statusText.Position=Vector2.new(rp.X,healthBarY+12)  
        v.statusText.Visible=true  

        local partPositions={}  
        for i,partName in ipairs(v.partsToUse) do  
            local pos=getBodyPartPosition(c,partName)  
            if pos and v.dots[i] then v.dots[i].Position=pos v.dots[i].Visible=true partPositions[partName]=pos  
            elseif v.dots[i] then v.dots[i].Visible=false end  
        end  
        for lineIndex,link in ipairs(v.skeletonToUse) do  
            local startPart,endPart=link[1],link[2]  
            local startPos,endPos=partPositions[startPart],partPositions[endPart]  
            if startPos and endPos and v.skeletons[lineIndex] then v.skeletons[lineIndex].From=startPos v.skeletons[lineIndex].To=endPos v.skeletons[lineIndex].Visible=true  
            elseif v.skeletons[lineIndex] then v.skeletons[lineIndex].Visible=false end  
        end  
    else  
        for _,line in pairs(v.corners or {}) do line.Visible=false end  
        for _,line in pairs(v.fullBox or {}) do line.Visible=false end  
        if v.nameText then v.nameText.Visible=false end  
        if v.statusText then v.statusText.Visible=false end  
        if v.healthBarOutline then v.healthBarOutline.Visible=false end  
        if v.healthBarFill then v.healthBarFill.Visible=false end  
        for _,dot in pairs(v.dots or {}) do dot.Visible=false end  
        for _,line in pairs(v.skeletons or {}) do line.Visible=false end  
    end  
end

end)

local cleanupConnection=RunService.Heartbeat:Connect(cleanup)

local function addPlayerWithCharacterCheck(p)
if p==LocalPlayer then return end
local function handleCharacter(char)
if char:FindFirstChild("Humanoid") and not objects[p] then add(p,char) end
end
p.CharacterAdded:Connect(handleCharacter)
if p.Character then handleCharacter(p.Character) end
end

Players.PlayerAdded:Connect(addPlayerWithCharacterCheck)
Players.PlayerRemoving:Connect(remove)
for _,p in pairs(Players:GetPlayers()) do if p~=LocalPlayer then addPlayerWithCharacterCheck(p) end end
gui.Destroying:Connect(function()
if cleanupConnection then cleanupConnection:Disconnect() end
for p in pairs(objects) do remove(p) end
end)
