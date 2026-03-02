local function removeLava()
    for i, v in pairs(game.Workspace:GetDescendants()) do
        if v.Name == "Lava" then
            v:Destroy()
        end
    end
    for i, v in pairs(game.ReplicatedStorage:GetDescendants()) do
        if v.Name == "Lava" then
            v:Destroy()
        end
    end
end

removeLava()

local function removeLava()
    for i, v in pairs(game.Workspace:GetDescendants()) do
        if v.Name == "LavaParts" and v.Parent and v.Parent.Name == "CircleIsland" 
            and v.Parent.Parent and v.Parent.Parent.Name == "Map" then
            v:Destroy()
        end
    end

    for i, v in pairs(game.ReplicatedStorage:GetDescendants()) do
        if v.Name == "LavaParts" and v.Parent and v.Parent.Name == "CircleIsland" 
            and v.Parent.Parent and v.Parent.Parent.Name == "Map" then
            v:Destroy()
        end
    end
end

removeLava()
