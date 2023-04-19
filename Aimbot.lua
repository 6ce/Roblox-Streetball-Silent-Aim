--[[

FOOTING:

75 - https://ibb.co/tLQGGJq
80 - https://ibb.co/MSLK3fk
85 - https://ibb.co/LnSKJND
90 - https://ibb.co/GTg7p3g

]]

local Success, Error = pcall(function()
	getgenv().HandleRender:Disconnect()
	getgenv().HandleJump:Disconnect()
end)

if Success then
	getgenv().HandleRender = nil
	getgenv().HandleJump = nil
end

local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local Power = Player:WaitForChild("PlayerGui", 9e9).Power.PowerFrame.Power
local PowerEvent = Player.Character.E_V.AddPower

local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Footing = false
local HasBall = false
local ChangingPower = false
local Shooting = false
local Arc = "75"

local Function do
    for _, Obj in next, getgc(true) do
        if type(Obj) == "function" then
            local Info = getinfo(Obj)
            
            if Info.source:find("Tracker") and Info.numparams == 3 then
                Function = Obj
            end
        end
    end
end

local Goals = {} do
    for _, Obj in next, workspace:GetDescendants() do
	    if Obj:IsA("BasePart") and Obj.Name == "Lol" and Obj.Parent.Name == "Rim" then
		    table.insert(Goals, Obj)
	    end
	end
end

function CheckFooting()
	if HasBall then
		if Footing then
			if CoreGui:FindFirstChild("Highlight") then
			    if CoreGui:FindFirstChild("Highlight").Adornee.Parent == nil then
			        CoreGui:FindFirstChild("Highlight").Adornee = Player.Character
			    end
			    
				CoreGui:FindFirstChild("Highlight").Enabled = true
				CoreGui:FindFirstChild("Highlight").FillColor = Color3.fromRGB(0, 255, 0)
				CoreGui:FindFirstChild("Highlight").OutlineColor = Color3.fromRGB(25, 255, 25)
			else
				local Highlight = Instance.new("Highlight")
				Highlight.Parent = CoreGui
				Highlight.Adornee = Player.Character
				Highlight.Enabled = false
			end
		elseif not Footing and CoreGui:FindFirstChild("Highlight") then
			CoreGui:FindFirstChild("Highlight").Enabled = false
		end
	elseif not HasBall and CoreGui:FindFirstChild("Highlight") then
	    CoreGui:FindFirstChild("Highlight").Enabled = false
	end
end

function GetNearestGoal()
	local Goal, Distance = 9e9, math.huge

	for _, Obj in next, Goals do
	    local Mag = (Player.Character.Torso.Position - Obj.Position).Magnitude
	    
	    if Distance > Mag then
	        Goal = Obj
	        Distance = Mag
	    end
	end

	return Goal
end

function GetAddVector(Distance)
    if Arc == "75" then
        local Calculation = math.clamp((Distance / 15), 5.585, 5.65)
        
        return Vector3.new(0, 45 + Calculation, 0)
    elseif Arc == "80" then
        local Calculation = math.clamp((Distance / 15), 4.2, 4.24)
        
        return Vector3.new(0, 45 + Calculation, 0)
    elseif Arc == "85" then
        local Calculation = math.clamp((Distance / 15), 4.62, 6.65)
        
        return Vector3.new(0, 50 + Calculation, 0)
    elseif Arc == "90" then
        local Calculation = math.clamp((Distance / 15), 5.0099, 5.1)
        
        return Vector3.new(0, 55 + Calculation, 0)
    end
end

function GetNewVector(Goal)
	local Distance = (Player.Character.Torso.Position - Goal.Position).Magnitude
	local MoveDirection = Vector3.new(Player.Character.Humanoid.MoveDirection.X * 1.5, 0, Player.Character.Humanoid.MoveDirection.Z * 1.5)
	local AddVector = GetAddVector(Distance)
	
    return Goal.Position + AddVector - MoveDirection
end

function ShootBall()
	local Basketball = Player.Character:FindFirstChild("Basketball")
	local ShootEvent = Basketball["shoot_event"]

    local Goal = GetNearestGoal()
    local Vector = GetNewVector(Goal)
	local Unit = (Vector - Player.Character.Head.Position).Unit
	local SpawnPosition = Player.Character.PrimaryPart.Position + Unit * 3.8

	if SpawnPosition.Y - Player.Character.PrimaryPart.Position.Y < 4 then
		SpawnPosition = Player.Character.PrimaryPart.Position + Unit * 4
	end
    
    ShootEvent:FireServer(Vector, SpawnPosition, "\240\159\148\165\240\159\148\165")
    
    Shooting = false
end

function ChangePower(EndPower)
    while task.wait() do
        if Player.Character == nil or Player.Character:FindFirstChild("Basketball") == nil then
            break
        end
        
        if tonumber(Power.Text) > EndPower and not ChangingPower then
            ChangingPower = true
            PowerEvent:FireServer(-5)
            task.wait(0.2)
            ChangingPower = false
        elseif tonumber(Power.Text) < EndPower and not ChangingPower then
            ChangingPower = true
            PowerEvent:FireServer(5)
            task.wait(0.2)
            ChangingPower = false
        end
        
        if tonumber(Power.Text) == EndPower then
            ChangingPower = false
            break
        end
    end
end

function HandleJump()
	if HasBall and Footing and not Shooting then
	    Shooting = true
	    
		local Goal = GetNearestGoal()
		local Distance = (Player.Character.Torso.Position - Goal.Position).Magnitude
		
		if Distance >= 70 then
		    task.wait(0.24)
		    ShootBall()
		else
		    task.wait(0.225)
		    ShootBall()
		end
	end
end

function HandleRender()
	local Goal = GetNearestGoal()
	
	if Player.Character then
	    local PowerValue = Player.Character.E_V.Power.Value
	    local Distance = (Player.Character.Torso.Position - Goal.Position).Magnitude

	    if math.floor(Distance) == 57 and not ChangingPower and PowerValue ~= 75 then
	        ChangePower(75)
	    elseif math.floor(Distance) == 64 and not ChangingPower and PowerValue ~= 80 then
	        ChangePower(80)
	    elseif math.floor(Distance) == 70 and not ChangingPower and PowerValue ~= 85 then
	        ChangePower(85)
        elseif math.floor(Distance) == 76 and not ChangingPower and PowerValue ~= 90 then
	        ChangePower(90)
        end
        
        if PowerValue >= 75 and PowerValue <= 90 then
            Arc = tostring(PowerValue)
        end
        
        if math.floor(Distance) == 57 then
	        Footing = true
	    elseif math.floor(Distance) == 64 then
	        Footing = true
	    elseif math.floor(Distance) == 70 then
	        Footing = true
        elseif math.floor(Distance) == 76 then
	        Footing = true
	    else
	        Footing = false
        end
	end

	if Player.Character and Player.Character:FindFirstChildOfClass("Tool") then
		task.wait(0.5)
		if Player.Character:FindFirstChildOfClass("Tool") then
		    HasBall = true
		end
	elseif Player.Character and not Player.Character:FindFirstChildOfClass("Tool") then
		HasBall = false
	end

	CheckFooting()
end

getgenv().HandleJump = Player.Character.Humanoid.Jumping:Connect(HandleJump)
getgenv().HandleRender = RunService.Stepped:Connect(HandleRender)

Player.CharacterAdded:Connect(function(Character)
    Power = Player:WaitForChild("PlayerGui", 9e9):WaitForChild("Power", 9e9).PowerFrame.Power
    PowerEvent = Character:WaitForChild("AddPower")
    
    pcall(function()
	    getgenv().HandleJump:Disconnect()
	    getgenv().HandleJump = nil
	    getgenv().HandleRender:Disconnect()
	    getgenv().HandleRender = nil
    end)

	getgenv().HandleJump = Character:WaitForChild("Humanoid").Jumping:Connect(HandleJump)
	getgenv().HandleRender = RunService.Stepped:Connect(HandleRender)
end)

if not getgenv().Hooked then
    getgenv().Hooked = true
    
    local Hook do
        Hook = hookmetamethod(game, "__index", newcclosure(function(Self, Index)
            
            if Self == Mouse and Index == "Hit" and Shooting == true then
                local Goal = GetNearestGoal()
                local Vector = GetNewVector(Goal)
                
                if Goal ~= nil and Vector ~= nil then
                    return CFrame.new(Vector)
                end
            end
            
            return Hook(Self, Index)
        end))
    end
end
